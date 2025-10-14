import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export interface Doctor {
  id: string;
  full_name: string;
  specialization: string;
  email: string;
  phone: string;
  experience_years: number;
  qualification: string;
  created_at: string;
  updated_at: string;
}

export interface Patient {
  id: string;
  full_name: string;
  email: string;
  phone: string;
  date_of_birth: string;
  gender: string;
  blood_group?: string;
  address?: string;
  emergency_contact?: string;
  created_at: string;
  updated_at: string;
}

export interface Appointment {
  id: string;
  patient_id: string;
  doctor_id: string;
  appointment_date: string;
  appointment_time: string;
  status: 'scheduled' | 'completed' | 'cancelled';
  reason: string;
  notes?: string;
  created_at: string;
  updated_at: string;
  patients?: Patient;
  doctors?: Doctor;
}
