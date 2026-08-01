import { Response, NextFunction } from 'express';
import prisma from '../utils/prisma';
import { updateProfileSchema, createEmployeeSchema, adminUpdateEmployeeSchema } from '../validations/employee';
import { AuthRequest } from '../middlewares/auth';
import bcrypt from 'bcrypt';

import { uploadBufferToBlob, deleteBlob, generateSASUrl } from '../utils/storage';
import path from 'path';

const getFullPhotoUrl = async (req: AuthRequest, photoPath: string | null) => {
  if (!photoPath) return null;
  // If it's already an http URL (e.g. from local seed or something), return it
  if (photoPath.startsWith('http')) return photoPath;
  return await generateSASUrl(photoPath);
};

export const getMe = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user!.id },
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        phoneNumber: true,
        department: true,
        designation: true,
        photoPath: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({
      ...user,
      photoUrl: await getFullPhotoUrl(req, user.photoPath),
    });
  } catch (error) {
    next(error);
  }
};

export const updateMe = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const data = updateProfileSchema.parse(req.body);

    const user = await prisma.user.update({
      where: { id: req.user!.id },
      data,
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        phoneNumber: true,
        department: true,
        designation: true,
        photoPath: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    res.json({
      ...user,
      photoUrl: await getFullPhotoUrl(req, user.photoPath),
    });
  } catch (error) {
    next(error);
  }
};

export const uploadMyPhoto = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No file uploaded' });
    }

    const employeeId = req.user!.id;
    const ext = path.extname(req.file.originalname);
    const blobName = `employees/${employeeId}/profile${ext}`;
    
    // Check if user already has a photo
    const existingUser = await prisma.user.findUnique({ where: { id: employeeId } });
    if (existingUser?.photoPath && existingUser.photoPath !== blobName) {
      await deleteBlob(existingUser.photoPath);
    }

    await uploadBufferToBlob(req.file.buffer, blobName, req.file.mimetype);

    const user = await prisma.user.update({
      where: { id: employeeId },
      data: { photoPath: blobName },
      select: {
        id: true,
        photoPath: true,
      },
    });

    res.json({
      message: 'Photo uploaded successfully',
      photoUrl: await getFullPhotoUrl(req, user.photoPath),
    });
  } catch (error) {
    next(error);
  }
};

// --- ADMIN ENDPOINTS ---

export const getAllEmployees = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const employees = await prisma.user.findMany({
      select: {
        id: true,
        email: true,
        role: true,
        firstName: true,
        lastName: true,
        phoneNumber: true,
        department: true,
        designation: true,
        photoPath: true,
        createdAt: true,
        updatedAt: true,
      },
      orderBy: { createdAt: 'desc' }
    });

    const employeesWithUrl = await Promise.all(
      employees.map(async emp => ({
        ...emp,
        photoUrl: await getFullPhotoUrl(req, emp.photoPath),
      }))
    );
    res.json(employeesWithUrl);
  } catch (error) {
    next(error);
  }
};

export const getEmployeeById = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const id = parseInt(req.params.id as string, 10);
    const employee = await prisma.user.findUnique({
      where: { id },
      select: {
        id: true,
        email: true,
        role: true,
        firstName: true,
        lastName: true,
        phoneNumber: true,
        department: true,
        designation: true,
        photoPath: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    if (!employee) {
      return res.status(404).json({ error: 'Employee not found' });
    }

    res.json({
      ...employee,
      photoUrl: await getFullPhotoUrl(req, employee.photoPath),
    });
  } catch (error) {
    next(error);
  }
};

export const createEmployee = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const data = createEmployeeSchema.parse(req.body);

    const existingUser = await prisma.user.findUnique({
      where: { email: data.email },
    });
    if (existingUser) {
      return res.status(400).json({ error: 'Email already exists' });
    }

    const hashedPassword = await bcrypt.hash(data.password, 10);

    const newEmployee = await prisma.user.create({
      data: {
        ...data,
        password: hashedPassword,
      },
      select: {
        id: true,
        email: true,
        role: true,
        firstName: true,
        lastName: true,
        phoneNumber: true,
        department: true,
        designation: true,
        photoPath: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    res.status(201).json({
      ...newEmployee,
      photoUrl: await getFullPhotoUrl(req, newEmployee.photoPath),
    });
  } catch (error) {
    next(error);
  }
};

export const updateEmployee = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const id = parseInt(req.params.id as string, 10);
    const data = adminUpdateEmployeeSchema.parse(req.body);

    let hashedPassword = undefined;
    if (data.password) {
      hashedPassword = await bcrypt.hash(data.password, 10);
    }

    const employee = await prisma.user.update({
      where: { id },
      data: {
        ...data,
        ...(hashedPassword && { password: hashedPassword }),
      },
      select: {
        id: true,
        email: true,
        role: true,
        firstName: true,
        lastName: true,
        phoneNumber: true,
        department: true,
        designation: true,
        photoPath: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    res.json({
      ...employee,
      photoUrl: await getFullPhotoUrl(req, employee.photoPath),
    });
  } catch (error) {
    // If not found, prisma throws an error which can be caught or we can check first
    // For simplicity, centralized error handler handles prisma errors as 500 right now.
    // If we want 404, we can add a check if needed, but it's fine for simple CRUD.
    if (error && (error as any).code === 'P2025') {
      return res.status(404).json({ error: 'Employee not found' });
    }
    next(error);
  }
};

export const deleteEmployee = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const id = parseInt(req.params.id as string, 10);
    
    // Check if it exists to return 404 if not found
    const existingUser = await prisma.user.findUnique({ where: { id } });
    if (!existingUser) {
      return res.status(404).json({ error: 'Employee not found' });
    }

    await prisma.user.delete({
      where: { id },
    });

    res.json({ message: 'Employee deleted successfully' });
  } catch (error) {
    next(error);
  }
};

export const uploadEmployeePhoto = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const id = parseInt(req.params.id as string, 10);

    if (!req.file) {
      return res.status(400).json({ error: 'No file uploaded' });
    }

    // Check if it exists
    const existingUser = await prisma.user.findUnique({ where: { id } });
    if (!existingUser) {
      return res.status(404).json({ error: 'Employee not found' });
    }

    const ext = path.extname(req.file.originalname);
    const blobName = `employees/${id}/profile${ext}`;
    
    if (existingUser.photoPath && existingUser.photoPath !== blobName) {
      await deleteBlob(existingUser.photoPath);
    }
    
    await uploadBufferToBlob(req.file.buffer, blobName, req.file.mimetype);

    const employee = await prisma.user.update({
      where: { id },
      data: { photoPath: blobName },
      select: {
        id: true,
        photoPath: true,
      },
    });

    res.json({
      message: 'Photo uploaded successfully',
      photoUrl: await getFullPhotoUrl(req, employee.photoPath),
    });
  } catch (error) {
    next(error);
  }
};
