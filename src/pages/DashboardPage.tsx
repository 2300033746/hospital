import { useState } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { LogOut, Users, Stethoscope, Calendar, Activity } from 'lucide-react';
import DoctorsModule from '../components/DoctorsModule';
import PatientsModule from '../components/PatientsModule';
import AppointmentsModule from '../components/AppointmentsModule';

type Module = 'doctors' | 'patients' | 'appointments';

export default function DashboardPage() {
  const [activeModule, setActiveModule] = useState<Module>('doctors');
  const { signOut, user } = useAuth();

  const handleSignOut = async () => {
    await signOut();
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <header className="bg-white border-b border-gray-200 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center gap-3">
              <div className="bg-blue-600 p-2 rounded-lg">
                <Activity className="w-6 h-6 text-white" />
              </div>
              <div>
                <h1 className="text-xl font-bold text-gray-900">Hospital Management System</h1>
                <p className="text-xs text-gray-500">{user?.email}</p>
              </div>
            </div>
            <button
              onClick={handleSignOut}
              className="flex items-center gap-2 px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg transition-colors"
            >
              <LogOut className="w-4 h-4" />
              <span className="font-medium">Sign Out</span>
            </button>
          </div>
        </div>
      </header>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
          <button
            onClick={() => setActiveModule('doctors')}
            className={`p-6 rounded-xl border-2 transition-all ${
              activeModule === 'doctors'
                ? 'bg-blue-50 border-blue-500 shadow-lg'
                : 'bg-white border-gray-200 hover:border-blue-300 hover:shadow-md'
            }`}
          >
            <div className="flex items-center gap-4">
              <div className={`p-3 rounded-lg ${activeModule === 'doctors' ? 'bg-blue-600' : 'bg-blue-100'}`}>
                <Stethoscope className={`w-6 h-6 ${activeModule === 'doctors' ? 'text-white' : 'text-blue-600'}`} />
              </div>
              <div className="text-left">
                <h3 className="font-semibold text-lg text-gray-900">Doctors</h3>
                <p className="text-sm text-gray-600">Manage medical staff</p>
              </div>
            </div>
          </button>

          <button
            onClick={() => setActiveModule('patients')}
            className={`p-6 rounded-xl border-2 transition-all ${
              activeModule === 'patients'
                ? 'bg-green-50 border-green-500 shadow-lg'
                : 'bg-white border-gray-200 hover:border-green-300 hover:shadow-md'
            }`}
          >
            <div className="flex items-center gap-4">
              <div className={`p-3 rounded-lg ${activeModule === 'patients' ? 'bg-green-600' : 'bg-green-100'}`}>
                <Users className={`w-6 h-6 ${activeModule === 'patients' ? 'text-white' : 'text-green-600'}`} />
              </div>
              <div className="text-left">
                <h3 className="font-semibold text-lg text-gray-900">Patients</h3>
                <p className="text-sm text-gray-600">Manage patient records</p>
              </div>
            </div>
          </button>

          <button
            onClick={() => setActiveModule('appointments')}
            className={`p-6 rounded-xl border-2 transition-all ${
              activeModule === 'appointments'
                ? 'bg-orange-50 border-orange-500 shadow-lg'
                : 'bg-white border-gray-200 hover:border-orange-300 hover:shadow-md'
            }`}
          >
            <div className="flex items-center gap-4">
              <div className={`p-3 rounded-lg ${activeModule === 'appointments' ? 'bg-orange-600' : 'bg-orange-100'}`}>
                <Calendar className={`w-6 h-6 ${activeModule === 'appointments' ? 'text-white' : 'text-orange-600'}`} />
              </div>
              <div className="text-left">
                <h3 className="font-semibold text-lg text-gray-900">Appointments</h3>
                <p className="text-sm text-gray-600">Schedule & manage</p>
              </div>
            </div>
          </button>
        </div>

        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          {activeModule === 'doctors' && <DoctorsModule />}
          {activeModule === 'patients' && <PatientsModule />}
          {activeModule === 'appointments' && <AppointmentsModule />}
        </div>
      </div>
    </div>
  );
}
