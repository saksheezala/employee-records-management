import { useState } from 'react';
import { NavLink, Outlet, useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { LayoutDashboard, Users, LogOut, Menu, X, UserCircle } from 'lucide-react';

export default function DashboardLayout() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [sidebarOpen, setSidebarOpen] = useState(false);

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  const navItems = [
    { name: 'Dashboard', path: '/admin/dashboard', icon: <LayoutDashboard size={20} /> },
    { name: 'Employees', path: '/admin/employees', icon: <Users size={20} /> },
  ];

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col md:flex-row">
      {/* Mobile Navbar */}
      <div className="md:hidden bg-white shadow-sm flex items-center justify-between p-4 sticky top-0 z-20">
        <div className="flex items-center space-x-2 text-blue-600 font-bold text-xl">
          <LayoutDashboard size={24} />
          <span>CloudDeploy</span>
        </div>
        <button onClick={() => setSidebarOpen(!sidebarOpen)} className="text-gray-600 focus:outline-none">
          {sidebarOpen ? <X size={24} /> : <Menu size={24} />}
        </button>
      </div>

      {/* Sidebar */}
      <div className={`fixed inset-y-0 left-0 transform ${sidebarOpen ? 'translate-x-0' : '-translate-x-full'} md:translate-x-0 md:static w-64 bg-white shadow-lg transition-transform duration-200 ease-in-out z-10 flex flex-col`}>
        <div className="p-6 hidden md:flex items-center space-x-2 text-blue-600 font-bold text-2xl border-b border-gray-100">
          <LayoutDashboard size={28} />
          <span>CloudDeploy</span>
        </div>

        <div className="p-4 flex-1">
          <ul className="space-y-2">
            {navItems.map((item) => (
              <li key={item.name}>
                <NavLink
                  to={item.path}
                  onClick={() => setSidebarOpen(false)}
                  className={({ isActive }) =>
                    `flex items-center space-x-3 px-4 py-3 rounded-lg transition-colors ${
                      isActive 
                        ? 'bg-blue-50 text-blue-700 font-medium' 
                        : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
                    }`
                  }
                >
                  {item.icon}
                  <span>{item.name}</span>
                </NavLink>
              </li>
            ))}
          </ul>
        </div>

        <div className="p-4 border-t border-gray-100">
          <div className="flex items-center space-x-3 px-4 py-3 mb-2 rounded-lg bg-gray-50 text-gray-700">
            {user?.photoUrl ? (
              <img src={user.photoUrl} alt="Profile" className="w-8 h-8 rounded-full object-cover" />
            ) : (
              <UserCircle size={32} className="text-gray-400" />
            )}
            <div className="flex flex-col truncate">
              <span className="text-sm font-medium truncate">{user?.firstName} {user?.lastName}</span>
              <span className="text-xs text-gray-500 truncate">{user?.role}</span>
            </div>
          </div>
          <button
            onClick={handleLogout}
            className="flex items-center space-x-3 px-4 py-3 rounded-lg w-full text-left text-red-600 hover:bg-red-50 transition-colors"
          >
            <LogOut size={20} />
            <span>Logout</span>
          </button>
        </div>
      </div>

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col min-w-0 overflow-hidden">
        {/* Top Navbar */}
        <header className="hidden md:flex bg-white shadow-sm h-16 items-center px-8 justify-end z-10 sticky top-0">
          <div className="flex items-center space-x-4">
            <span className="text-sm text-gray-600">Welcome back, <span className="font-medium text-gray-900">{user?.firstName}</span></span>
          </div>
        </header>

        {/* Main Content */}
        <main className="flex-1 overflow-y-auto p-4 md:p-8">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
