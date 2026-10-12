"use client";

import { motion } from 'framer-motion';
import { 
  Settings as SettingsIcon,
  User,
  Shield,
  Bell,
  Smartphone,
  Save,
  LogOut,
  Key
} from 'lucide-react';
import { useState } from 'react';

export default function SettingsPage() {
  const [activeTab, setActiveTab] = useState('Profile');

  return (
    <div className="space-y-6 max-w-7xl mx-auto h-full flex flex-col">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 shrink-0">
        <div>
          <h2 className="text-2xl font-bold text-rakshaa-navy flex items-center">
            <SettingsIcon className="mr-2 text-rakshaa-muted" size={24} />
            Platform Settings
          </h2>
          <p className="text-rakshaa-muted mt-1 text-sm">Manage your personal profile and system-wide configurations.</p>
        </div>
        
        <button className="flex items-center space-x-2 px-6 py-2.5 bg-rakshaa-coral text-white rounded-lg font-bold hover:bg-rakshaa-coral/90 transition-colors text-sm shadow-sm">
          <Save size={16} />
          <span>Save Changes</span>
        </button>
      </div>

      <div className="flex flex-col md:flex-row gap-8 flex-1 overflow-hidden">
        
        {/* Settings Navigation Sidebar */}
        <div className="w-full md:w-56 shrink-0 flex flex-row md:flex-col items-start md:items-stretch gap-2 overflow-x-auto md:overflow-visible scrollbar-hide border-b md:border-b-0 md:border-r border-rakshaa-border pb-4 md:pb-0 md:pr-6">
          <TabButton icon={User} label="Profile" active={activeTab === 'Profile'} onClick={() => setActiveTab('Profile')} />
          <TabButton icon={Shield} label="Security" active={activeTab === 'Security'} onClick={() => setActiveTab('Security')} />
          <TabButton icon={Bell} label="Notifications" active={activeTab === 'Notifications'} onClick={() => setActiveTab('Notifications')} />
          <TabButton icon={Smartphone} label="Integrations" active={activeTab === 'Integrations'} onClick={() => setActiveTab('Integrations')} />
          
          <div className="hidden md:block my-4 h-px bg-rakshaa-border" />
          
          <button className="flex items-center px-4 py-3 rounded-xl transition-colors text-rakshaa-danger hover:bg-rakshaa-danger/10 text-left font-medium w-max md:w-full whitespace-nowrap">
            <LogOut size={18} className="mr-3 shrink-0" />
            Sign Out
          </button>
        </div>

        {/* Settings Content Area */}
        <div className="flex-1 overflow-y-auto scrollbar-hide pb-12">
          
          {activeTab === 'Profile' && (
            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="max-w-2xl space-y-8">
              <div>
                <h3 className="text-lg font-bold text-rakshaa-navy mb-4">Personal Information</h3>
                <div className="bg-white p-6 rounded-xl border border-rakshaa-border shadow-sm space-y-4">
                  <div className="flex items-center space-x-6 mb-6">
                    <div className="w-20 h-20 bg-rakshaa-navy text-white rounded-full flex items-center justify-center text-2xl font-bold shadow-md">
                      AD
                    </div>
                    <div>
                      <button className="px-4 py-2 border border-rakshaa-border rounded-lg text-sm font-medium text-rakshaa-navy hover:bg-rakshaa-bg transition-colors">
                        Change Avatar
                      </button>
                      <p className="text-xs text-rakshaa-muted mt-2">JPG, GIF or PNG. Max size of 800K</p>
                    </div>
                  </div>
                  
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-semibold text-rakshaa-navy mb-1.5">First Name</label>
                      <input type="text" defaultValue="Admin" className="w-full px-4 py-2 rounded-lg border border-rakshaa-border bg-rakshaa-bg focus:bg-white focus:outline-none focus:border-rakshaa-coral text-sm" />
                    </div>
                    <div>
                      <label className="block text-sm font-semibold text-rakshaa-navy mb-1.5">Last Name</label>
                      <input type="text" defaultValue="User" className="w-full px-4 py-2 rounded-lg border border-rakshaa-border bg-rakshaa-bg focus:bg-white focus:outline-none focus:border-rakshaa-coral text-sm" />
                    </div>
                  </div>
                  
                  <div>
                    <label className="block text-sm font-semibold text-rakshaa-navy mb-1.5">Email Address</label>
                    <input type="email" defaultValue="admin@rakshaa.app" disabled className="w-full px-4 py-2 rounded-lg border border-rakshaa-border bg-gray-100 text-rakshaa-muted text-sm cursor-not-allowed" />
                    <p className="text-xs text-rakshaa-muted mt-1.5">Email cannot be changed directly. Contact super-admin.</p>
                  </div>
                </div>
              </div>
            </motion.div>
          )}

          {activeTab === 'Security' && (
            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="max-w-2xl space-y-8">
              <div>
                <h3 className="text-lg font-bold text-rakshaa-navy mb-4">Update Password</h3>
                <div className="bg-white p-6 rounded-xl border border-rakshaa-border shadow-sm space-y-4">
                  <div>
                    <label className="block text-sm font-semibold text-rakshaa-navy mb-1.5">Current Password</label>
                    <input type="password" placeholder="••••••••" className="w-full px-4 py-2 rounded-lg border border-rakshaa-border bg-rakshaa-bg focus:bg-white focus:outline-none focus:border-rakshaa-coral text-sm" />
                  </div>
                  <div>
                    <label className="block text-sm font-semibold text-rakshaa-navy mb-1.5">New Password</label>
                    <input type="password" placeholder="••••••••" className="w-full px-4 py-2 rounded-lg border border-rakshaa-border bg-rakshaa-bg focus:bg-white focus:outline-none focus:border-rakshaa-coral text-sm" />
                  </div>
                  <div>
                    <label className="block text-sm font-semibold text-rakshaa-navy mb-1.5">Confirm New Password</label>
                    <input type="password" placeholder="••••••••" className="w-full px-4 py-2 rounded-lg border border-rakshaa-border bg-rakshaa-bg focus:bg-white focus:outline-none focus:border-rakshaa-coral text-sm" />
                  </div>
                  <div className="pt-2">
                    <button className="flex items-center space-x-2 px-4 py-2 bg-rakshaa-navy text-white rounded-lg text-sm font-medium hover:bg-rakshaa-navy/90 transition-colors">
                      <Key size={16} />
                      <span>Update Password</span>
                    </button>
                  </div>
                </div>
              </div>

              <div>
                <h3 className="text-lg font-bold text-rakshaa-navy mb-4">Two-Factor Authentication</h3>
                <div className="bg-white p-6 rounded-xl border border-rakshaa-border shadow-sm flex items-center justify-between">
                  <div>
                    <p className="font-semibold text-rakshaa-navy">Secure your account</p>
                    <p className="text-sm text-rakshaa-muted mt-1">Add an extra layer of security to your admin account.</p>
                  </div>
                  <button className="px-4 py-2 border border-rakshaa-coral text-rakshaa-coral rounded-lg text-sm font-bold hover:bg-rakshaa-coral/10 transition-colors">
                    Enable 2FA
                  </button>
                </div>
              </div>
            </motion.div>
          )}

          {activeTab === 'Integrations' && (
            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="max-w-2xl space-y-8">
              <div>
                <h3 className="text-lg font-bold text-rakshaa-navy mb-4">External APIs</h3>
                <div className="bg-white p-6 rounded-xl border border-rakshaa-border shadow-sm space-y-6">
                  
                  <div className="flex items-center justify-between border-b border-rakshaa-border pb-6">
                    <div>
                      <p className="font-semibold text-rakshaa-navy">Twilio SMS Gateway</p>
                      <p className="text-sm text-rakshaa-muted mt-1">Used for delivering offline emergency alerts.</p>
                    </div>
                    <div className="flex items-center space-x-3">
                      <span className="text-xs font-bold text-rakshaa-success bg-rakshaa-success/10 px-2 py-1 rounded">CONNECTED</span>
                      <button className="text-sm font-medium text-blue-600 hover:underline">Configure</button>
                    </div>
                  </div>

                  <div className="flex items-center justify-between border-b border-rakshaa-border pb-6">
                    <div>
                      <p className="font-semibold text-rakshaa-navy">WhatsApp Business API</p>
                      <p className="text-sm text-rakshaa-muted mt-1">Used for rich media safety alerts.</p>
                    </div>
                    <div className="flex items-center space-x-3">
                      <span className="text-xs font-bold text-rakshaa-success bg-rakshaa-success/10 px-2 py-1 rounded">CONNECTED</span>
                      <button className="text-sm font-medium text-blue-600 hover:underline">Configure</button>
                    </div>
                  </div>
                  
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-semibold text-rakshaa-navy">Google Maps API</p>
                      <p className="text-sm text-rakshaa-muted mt-1">For live tracking and heatmaps.</p>
                    </div>
                    <div className="flex items-center space-x-3">
                      <span className="text-xs font-bold text-rakshaa-warning bg-rakshaa-warning/10 px-2 py-1 rounded">NEEDS UPDATE</span>
                      <button className="text-sm font-medium text-blue-600 hover:underline">Configure</button>
                    </div>
                  </div>

                </div>
              </div>
            </motion.div>
          )}

          {activeTab === 'Notifications' && (
            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="max-w-2xl space-y-8">
              <div>
                <h3 className="text-lg font-bold text-rakshaa-navy mb-4">Alert Preferences</h3>
                <div className="bg-white p-6 rounded-xl border border-rakshaa-border shadow-sm space-y-4">
                  
                  <ToggleRow title="Critical Emergency Alerts" desc="Receive push notifications when a user triggers an emergency." defaultChecked={true} />
                  <ToggleRow title="Daily Summary Reports" desc="Receive a daily email with system statistics." defaultChecked={false} />
                  <ToggleRow title="New User Registrations" desc="Notify when a new user joins the platform." defaultChecked={true} />
                  <ToggleRow title="Failed API Webhooks" desc="Immediate alerts if Twilio or WhatsApp integrations fail." defaultChecked={true} />

                </div>
              </div>
            </motion.div>
          )}

        </div>
      </div>
    </div>
  );
}

function TabButton({ icon: Icon, label, active, onClick }: any) {
  return (
    <button 
      onClick={onClick}
      className={`flex items-center px-4 py-3 rounded-xl transition-colors whitespace-nowrap ${
        active 
          ? 'bg-rakshaa-navy text-white font-semibold shadow-sm' 
          : 'text-rakshaa-muted hover:bg-white hover:text-rakshaa-navy font-medium'
      }`}
    >
      <Icon size={18} className="mr-3 shrink-0" />
      {label}
    </button>
  );
}

function ToggleRow({ title, desc, defaultChecked }: any) {
  const [checked, setChecked] = useState(defaultChecked);
  return (
    <div className="flex items-center justify-between py-3 border-b border-rakshaa-border last:border-0 last:pb-0">
      <div className="pr-8">
        <p className="font-semibold text-rakshaa-navy">{title}</p>
        <p className="text-sm text-rakshaa-muted mt-0.5">{desc}</p>
      </div>
      <button 
        onClick={() => setChecked(!checked)}
        className={`relative w-12 h-6 rounded-full transition-colors shrink-0 ${checked ? 'bg-rakshaa-success' : 'bg-gray-300'}`}
      >
        <motion.div 
          animate={{ x: checked ? 26 : 2 }}
          className="absolute top-1 left-0 w-4 h-4 bg-white rounded-full shadow-sm"
        />
      </button>
    </div>
  );
}
