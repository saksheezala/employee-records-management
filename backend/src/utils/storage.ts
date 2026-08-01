import { 
  BlobServiceClient, 
  generateBlobSASQueryParameters, 
  BlobSASPermissions, 
} from '@azure/storage-blob';
import { DefaultAzureCredential } from '@azure/identity';

// For local development, we might not have a managed identity. DefaultAzureCredential handles fallback.
// In Azure App Service, it will automatically use the System Assigned Managed Identity.
let blobServiceClient: BlobServiceClient;
const containerName = process.env.STORAGE_CONTAINER_NAME || 'profile-photos';

if (process.env.STORAGE_ACCOUNT_NAME) {
  const accountUrl = `https://${process.env.STORAGE_ACCOUNT_NAME}.blob.core.windows.net`;
  const credential = new DefaultAzureCredential();
  blobServiceClient = new BlobServiceClient(accountUrl, credential);
} else {
  console.warn("STORAGE_ACCOUNT_NAME is not defined. Blob storage will not work properly.");
}

export const uploadBufferToBlob = async (
  buffer: Buffer, 
  blobName: string, 
  contentType: string
): Promise<string> => {
  if (!blobServiceClient) throw new Error("Azure Blob Storage not configured");
  
  const containerClient = blobServiceClient.getContainerClient(containerName);
  const blockBlobClient = containerClient.getBlockBlobClient(blobName);
  
  await blockBlobClient.uploadData(buffer, {
    blobHTTPHeaders: {
      blobContentType: contentType
    }
  });
  
  return blobName;
};

export const deleteBlob = async (blobName: string): Promise<void> => {
  if (!blobServiceClient) return;
  const containerClient = blobServiceClient.getContainerClient(containerName);
  const blockBlobClient = containerClient.getBlockBlobClient(blobName);
  
  try {
    await blockBlobClient.deleteIfExists();
  } catch (error) {
    console.error(`Failed to delete old blob ${blobName}`, error);
  }
};

export const generateSASUrl = async (blobName: string): Promise<string> => {
  if (!blobServiceClient) return '';
  
  const containerClient = blobServiceClient.getContainerClient(containerName);
  const blockBlobClient = containerClient.getBlockBlobClient(blobName);
  
  // Create a SAS token that expires in 15 minutes
  const startsOn = new Date();
  startsOn.setMinutes(startsOn.getMinutes() - 1); // 1 minute leeway for clock skew
  const expiresOn = new Date(startsOn);
  expiresOn.setMinutes(expiresOn.getMinutes() + 16); // 15 mins validity
  
  // When using Azure AD authentication (Managed Identity), we must use User Delegation SAS.
  // Wait, User Delegation SAS requires fetching a user delegation key first.
  const credential = new DefaultAzureCredential();
  const userDelegationKey = await blobServiceClient.getUserDelegationKey(startsOn, expiresOn);
  
  const sasOptions = {
    containerName,
    blobName,
    permissions: BlobSASPermissions.parse("r"),
    startsOn,
    expiresOn,
  };
  
  const sasToken = generateBlobSASQueryParameters(
    sasOptions,
    userDelegationKey,
    process.env.STORAGE_ACCOUNT_NAME!
  ).toString();
  
  return `${blockBlobClient.url}?${sasToken}`;
};
