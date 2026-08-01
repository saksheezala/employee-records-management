import { PrismaClient, Role } from '@prisma/client';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const adminPassword = await bcrypt.hash('admin123', 10);
  const employeePassword = await bcrypt.hash('employee123', 10);

  const admin = await prisma.user.upsert({
    where: { email: 'admin@company.com' },
    update: {},
    create: {
      email: 'admin@company.com',
      password: adminPassword,
      role: Role.ADMIN,
      firstName: 'Admin',
      lastName: 'User',
      department: 'IT',
      designation: 'System Administrator',
    },
  });

  const emp1 = await prisma.user.upsert({
    where: { email: 'john@company.com' },
    update: {},
    create: {
      email: 'john@company.com',
      password: employeePassword,
      role: Role.EMPLOYEE,
      firstName: 'John',
      lastName: 'Doe',
      department: 'Engineering',
      designation: 'Software Engineer',
    },
  });

  const emp2 = await prisma.user.upsert({
    where: { email: 'jane@company.com' },
    update: {},
    create: {
      email: 'jane@company.com',
      password: employeePassword,
      role: Role.EMPLOYEE,
      firstName: 'Jane',
      lastName: 'Smith',
      department: 'Marketing',
      designation: 'Marketing Manager',
    },
  });

  console.log({ admin, emp1, emp2 });
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
