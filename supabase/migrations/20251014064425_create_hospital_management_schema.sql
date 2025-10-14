/*
  # Hospital Management System Database Schema

  ## Overview
  Creates a comprehensive hospital management system with authentication and full CRUD capabilities.

  ## New Tables
  
  ### 1. `doctors`
  - `id` (uuid, primary key) - Unique identifier for each doctor
  - `user_id` (uuid, references auth.users) - Links doctor to authenticated user
  - `full_name` (text) - Doctor's full name
  - `specialization` (text) - Medical specialization
  - `email` (text) - Contact email
  - `phone` (text) - Contact phone number
  - `experience_years` (integer) - Years of medical experience
  - `qualification` (text) - Medical degrees and qualifications
  - `created_at` (timestamptz) - Record creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ### 2. `patients`
  - `id` (uuid, primary key) - Unique identifier for each patient
  - `user_id` (uuid, references auth.users) - Links patient to authenticated user
  - `full_name` (text) - Patient's full name
  - `email` (text) - Contact email
  - `phone` (text) - Contact phone number
  - `date_of_birth` (date) - Patient's date of birth
  - `gender` (text) - Patient's gender
  - `blood_group` (text) - Patient's blood group
  - `address` (text) - Residential address
  - `emergency_contact` (text) - Emergency contact information
  - `created_at` (timestamptz) - Record creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ### 3. `appointments`
  - `id` (uuid, primary key) - Unique identifier for each appointment
  - `patient_id` (uuid, references patients) - Patient booking the appointment
  - `doctor_id` (uuid, references doctors) - Doctor assigned to appointment
  - `appointment_date` (date) - Date of appointment
  - `appointment_time` (time) - Time of appointment
  - `status` (text) - Appointment status (scheduled, completed, cancelled)
  - `reason` (text) - Reason for visit
  - `notes` (text) - Additional notes
  - `created_by` (uuid, references auth.users) - User who created the appointment
  - `created_at` (timestamptz) - Record creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ## Security
  
  ### Row Level Security (RLS)
  All tables have RLS enabled with the following policies:
  
  #### Doctors Table
  1. Authenticated users can view all doctors
  2. Only authenticated users can create doctor records
  3. Only authenticated users can update doctor records
  4. Only authenticated users can delete doctor records
  
  #### Patients Table
  1. Authenticated users can view all patients
  2. Only authenticated users can create patient records
  3. Only authenticated users can update patient records
  4. Only authenticated users can delete patient records
  
  #### Appointments Table
  1. Authenticated users can view all appointments
  2. Only authenticated users can create appointments
  3. Only authenticated users can update appointments
  4. Only authenticated users can delete appointments

  ## Indexes
  - Index on doctors.user_id for faster user lookups
  - Index on patients.user_id for faster user lookups
  - Index on appointments.patient_id for faster patient appointment lookups
  - Index on appointments.doctor_id for faster doctor schedule lookups
  - Index on appointments.appointment_date for faster date-based queries
*/

-- Create doctors table
CREATE TABLE IF NOT EXISTS doctors (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name text NOT NULL,
  specialization text NOT NULL,
  email text NOT NULL,
  phone text NOT NULL,
  experience_years integer DEFAULT 0,
  qualification text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create patients table
CREATE TABLE IF NOT EXISTS patients (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name text NOT NULL,
  email text NOT NULL,
  phone text NOT NULL,
  date_of_birth date NOT NULL,
  gender text NOT NULL,
  blood_group text,
  address text,
  emergency_contact text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create appointments table
CREATE TABLE IF NOT EXISTS appointments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id uuid REFERENCES patients(id) ON DELETE CASCADE NOT NULL,
  doctor_id uuid REFERENCES doctors(id) ON DELETE CASCADE NOT NULL,
  appointment_date date NOT NULL,
  appointment_time time NOT NULL,
  status text DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled')),
  reason text NOT NULL,
  notes text,
  created_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_doctors_user_id ON doctors(user_id);
CREATE INDEX IF NOT EXISTS idx_patients_user_id ON patients(user_id);
CREATE INDEX IF NOT EXISTS idx_appointments_patient_id ON appointments(patient_id);
CREATE INDEX IF NOT EXISTS idx_appointments_doctor_id ON appointments(doctor_id);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON appointments(appointment_date);

-- Enable Row Level Security
ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;

-- Doctors policies
CREATE POLICY "Authenticated users can view all doctors"
  ON doctors FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can create doctors"
  ON doctors FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update doctors"
  ON doctors FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete doctors"
  ON doctors FOR DELETE
  TO authenticated
  USING (true);

-- Patients policies
CREATE POLICY "Authenticated users can view all patients"
  ON patients FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can create patients"
  ON patients FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update patients"
  ON patients FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete patients"
  ON patients FOR DELETE
  TO authenticated
  USING (true);

-- Appointments policies
CREATE POLICY "Authenticated users can view all appointments"
  ON appointments FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can create appointments"
  ON appointments FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update appointments"
  ON appointments FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete appointments"
  ON appointments FOR DELETE
  TO authenticated
  USING (true);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers to automatically update updated_at
CREATE TRIGGER update_doctors_updated_at
  BEFORE UPDATE ON doctors
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_patients_updated_at
  BEFORE UPDATE ON patients
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_appointments_updated_at
  BEFORE UPDATE ON appointments
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();