# Employee Records Management API

This document describes all the backend endpoints available in the application.

## 1. System

### Health Check
- **Method:** `GET`
- **URL:** `/health`
- **Purpose:** Verifies that the backend server is running. Used for Docker and Azure App Service health checks.
- **Authentication Required:** No
- **Required Role:** Public
- **Request Body:** None
- **Request Parameters:** None
- **Successful Response:** `200 OK`
  ```json
  { "status": "ok" }
  ```
- **Possible Error Responses:** None

---

## 2. Authentication

### Login
- **Method:** `POST`
- **URL:** `/api/auth/login`
- **Purpose:** Authenticates a user and returns a JSON Web Token (JWT).
- **Authentication Required:** No
- **Required Role:** Public
- **Request Body:**
  ```json
  {
    "email": "user@company.com",
    "password": "yourpassword"
  }
  ```
- **Request Parameters:** None
- **Successful Response:** `200 OK`
  ```json
  {
    "token": "eyJhbGciOi...",
    "user": {
      "id": 1,
      "email": "user@company.com",
      "role": "EMPLOYEE",
      "firstName": "John",
      "lastName": "Doe"
    }
  }
  ```
- **Possible Error Responses:**
  - `400 Bad Request`: Validation error
  - `401 Unauthorized`: Invalid credentials

---

## 3. Employee (Self-Service)

### Get Own Profile
- **Method:** `GET`
- **URL:** `/api/employees/me`
- **Purpose:** Retrieves the profile information of the currently authenticated user.
- **Authentication Required:** Yes
- **Required Role:** Employee or Admin
- **Request Body:** None
- **Request Parameters:** None
- **Successful Response:** `200 OK`
  ```json
  {
    "id": 2,
    "email": "john@company.com",
    "firstName": "John",
    "lastName": "Doe",
    "phoneNumber": "+1234567890",
    "department": "Engineering",
    "designation": "Software Engineer",
    "photoPath": "uploads/photo-123.jpg",
    "createdAt": "2026-07-31T12:00:00Z",
    "updatedAt": "2026-07-31T12:00:00Z",
    "photoUrl": "http://localhost:3000/uploads/photo-123.jpg"
  }
  ```
- **Possible Error Responses:**
  - `401 Unauthorized`: Invalid or missing token
  - `404 Not Found`: User not found

### Update Own Profile
- **Method:** `PUT`
- **URL:** `/api/employees/me`
- **Purpose:** Updates the profile information of the currently authenticated user.
- **Authentication Required:** Yes
- **Required Role:** Employee or Admin
- **Request Body:** (All fields optional)
  ```json
  {
    "firstName": "Jonathan",
    "lastName": "Doe",
    "phoneNumber": "+1987654321",
    "department": "Engineering",
    "designation": "Senior Engineer"
  }
  ```
- **Request Parameters:** None
- **Successful Response:** `200 OK` (Returns the updated user object, similar to Get Own Profile)
- **Possible Error Responses:**
  - `400 Bad Request`: Validation error
  - `401 Unauthorized`: Invalid or missing token

### Upload Own Profile Photo
- **Method:** `POST`
- **URL:** `/api/employees/me/photo`
- **Purpose:** Uploads or replaces the profile photo for the currently authenticated user.
- **Authentication Required:** Yes
- **Required Role:** Employee or Admin
- **Request Body:** `multipart/form-data` with a `photo` field containing the image file.
- **Request Parameters:** None
- **Successful Response:** `200 OK`
  ```json
  {
    "message": "Photo uploaded successfully",
    "photoUrl": "http://localhost:3000/uploads/photo-123.jpg"
  }
  ```
- **Possible Error Responses:**
  - `400 Bad Request`: No file uploaded or invalid file type
  - `401 Unauthorized`: Invalid or missing token

---

## 4. Admin (Employee Management)

### Get All Employees
- **Method:** `GET`
- **URL:** `/api/employees`
- **Purpose:** Retrieves a list of all employees in the system.
- **Authentication Required:** Yes
- **Required Role:** Admin
- **Request Body:** None
- **Request Parameters:** None
- **Successful Response:** `200 OK`
  ```json
  [
    {
      "id": 2,
      "email": "john@company.com",
      "role": "EMPLOYEE",
      "firstName": "John",
      "lastName": "Doe",
      "...": "..."
    }
  ]
  ```
- **Possible Error Responses:**
  - `401 Unauthorized`: Invalid or missing token
  - `403 Forbidden`: Authenticated user is not an Admin

### Get Employee by ID
- **Method:** `GET`
- **URL:** `/api/employees/:id`
- **Purpose:** Retrieves details for a specific employee.
- **Authentication Required:** Yes
- **Required Role:** Admin
- **Request Body:** None
- **Request Parameters:** 
  - `id` (Number): The ID of the employee to retrieve.
- **Successful Response:** `200 OK` (Returns the user object)
- **Possible Error Responses:**
  - `401 Unauthorized`: Invalid or missing token
  - `403 Forbidden`: Not an Admin
  - `404 Not Found`: Employee does not exist

### Create Employee
- **Method:** `POST`
- **URL:** `/api/employees`
- **Purpose:** Creates a new employee record.
- **Authentication Required:** Yes
- **Required Role:** Admin
- **Request Body:**
  ```json
  {
    "email": "new@company.com",
    "password": "securepassword",
    "firstName": "New",
    "lastName": "User",
    "phoneNumber": "123",
    "department": "HR",
    "designation": "Manager"
  }
  ```
- **Request Parameters:** None
- **Successful Response:** `201 Created` (Returns the newly created user object)
- **Possible Error Responses:**
  - `400 Bad Request`: Validation error or Email already exists
  - `401 Unauthorized`: Invalid or missing token
  - `403 Forbidden`: Not an Admin

### Update Employee
- **Method:** `PUT`
- **URL:** `/api/employees/:id`
- **Purpose:** Updates an existing employee record.
- **Authentication Required:** Yes
- **Required Role:** Admin
- **Request Body:** (All fields optional, including `password`)
  ```json
  {
    "department": "Finance"
  }
  ```
- **Request Parameters:** 
  - `id` (Number): The ID of the employee to update.
- **Successful Response:** `200 OK` (Returns the updated user object)
- **Possible Error Responses:**
  - `400 Bad Request`: Validation error
  - `401 Unauthorized`: Invalid or missing token
  - `403 Forbidden`: Not an Admin
  - `404 Not Found`: Employee does not exist

### Delete Employee
- **Method:** `DELETE`
- **URL:** `/api/employees/:id`
- **Purpose:** Deletes an existing employee record.
- **Authentication Required:** Yes
- **Required Role:** Admin
- **Request Body:** None
- **Request Parameters:** 
  - `id` (Number): The ID of the employee to delete.
- **Successful Response:** `200 OK`
  ```json
  {
    "message": "Employee deleted successfully"
  }
  ```
- **Possible Error Responses:**
  - `401 Unauthorized`: Invalid or missing token
  - `403 Forbidden`: Not an Admin
  - `404 Not Found`: Employee does not exist

### Upload Employee Photo
- **Method:** `POST`
- **URL:** `/api/employees/:id/photo`
- **Purpose:** Uploads or replaces the profile photo for a specific employee.
- **Authentication Required:** Yes
- **Required Role:** Admin
- **Request Body:** `multipart/form-data` with a `photo` field containing the image file.
- **Request Parameters:** 
  - `id` (Number): The ID of the employee.
- **Successful Response:** `200 OK`
  ```json
  {
    "message": "Photo uploaded successfully",
    "photoUrl": "http://localhost:3000/uploads/photo-123.jpg"
  }
  ```
- **Possible Error Responses:**
  - `400 Bad Request`: No file uploaded or invalid file type
  - `401 Unauthorized`: Invalid or missing token
  - `403 Forbidden`: Not an Admin
  - `404 Not Found`: Employee does not exist
