"use client";

import { motion } from 'framer-motion';
import { 
  BarChart3,
  TrendingUp,
  Activity,
  Calendar
} from 'lucide-react';
import { 
  LineChart, 
  Line, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  ResponsiveContainer,
  BarChart,
  Bar,
  Legend
} from 'recharts';

const emergencyData = [
  { name: 'Mon', count: 12 },
  { name: 'Tue', count: 15 },
  { name: 'Wed', count: 8 },
  { name: 'Thu', count: 24 },
  { name: 'Fri', count: 32 },
  { name: 'Sat', count: 45 },
  { name: 'Sun', count: 28 },
];

const alertData = [
  { name: 'WhatsApp', delivered: 8400, failed: 120 },
  { name: 'SMS', delivered: 6200, failed: 340 },
  { name: 'Push', delivered: 12000, failed: 45 },
];

export default function AnalyticsPage() {
  return (
    <div className="space-y-6 max-w-7xl mx-auto h-full flex flex-col">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 shrink-0">
        <div>
          <h2 className="text-2xl font-bold text-rakshaa-navy">Reports & Analytics</h2>
          <p className="text-rakshaa-muted mt-1 text-sm">Monitor platform usage and safety trends.</p>
        </div>
        
        <div className="flex items-center space-x-3">
          <button className="flex items-center space-x-2 px-4 py-2 bg-white border border-rakshaa-border rounded-lg text-rakshaa-navy font-medium hover:bg-rakshaa-bg transition-colors text-sm">
            <Calendar size={16} />
            <span>Last 7 Days</span>
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 flex-1 overflow-y-auto scrollbar-hide pb-8">
        
        {/* Emergency Trends Chart */}
        <div className="bg-white border border-rakshaa-border rounded-xl p-6 shadow-sm flex flex-col h-[400px]">
          <div className="flex justify-between items-center mb-6">
            <div>
              <h3 className="font-bold text-rakshaa-navy flex items-center">
                <TrendingUp size={18} className="mr-2 text-rakshaa-coral" /> Emergency Trends
              </h3>
              <p className="text-xs text-rakshaa-muted mt-1">Total emergencies activated per day</p>
            </div>
            <span className="text-rakshaa-success font-bold text-sm bg-rakshaa-success/10 px-2 py-1 rounded">+14%</span>
          </div>
          <div className="flex-1 w-full">
            <ResponsiveContainer width="100%" height="100%">
              <LineChart data={emergencyData} margin={{ top: 5, right: 20, bottom: 5, left: 0 }}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#E7E9EF" />
                <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#71809A' }} />
                <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#71809A' }} />
                <Tooltip 
                  contentStyle={{ borderRadius: '8px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
                  cursor={{ stroke: '#E7E9EF', strokeWidth: 2 }}
                />
                <Line type="monotone" dataKey="count" stroke="#FF5B64" strokeWidth={3} dot={{ r: 4, strokeWidth: 2 }} activeDot={{ r: 6 }} />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Alert Delivery Chart */}
        <div className="bg-white border border-rakshaa-border rounded-xl p-6 shadow-sm flex flex-col h-[400px]">
          <div className="flex justify-between items-center mb-6">
            <div>
              <h3 className="font-bold text-rakshaa-navy flex items-center">
                <BarChart3 size={18} className="mr-2 text-rakshaa-navy" /> Alert Delivery
              </h3>
              <p className="text-xs text-rakshaa-muted mt-1">Delivery success across channels</p>
            </div>
          </div>
          <div className="flex-1 w-full">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={alertData} margin={{ top: 5, right: 20, bottom: 5, left: 0 }}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#E7E9EF" />
                <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#71809A' }} />
                <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#71809A' }} />
                <Tooltip 
                  contentStyle={{ borderRadius: '8px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
                  cursor={{ fill: '#F7F8FA' }}
                />
                <Legend iconType="circle" wrapperStyle={{ fontSize: 12 }} />
                <Bar dataKey="delivered" name="Delivered" fill="#172B4D" radius={[4, 4, 0, 0]} />
                <Bar dataKey="failed" name="Failed" fill="#D94A57" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Quick Stats */}
        <div className="lg:col-span-2 grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="bg-white border border-rakshaa-border rounded-xl p-6 shadow-sm">
            <h4 className="text-sm font-semibold text-rakshaa-muted uppercase tracking-wider mb-2">Avg Resolution Time</h4>
            <div className="flex items-end space-x-3">
              <span className="text-3xl font-bold text-rakshaa-navy">12m 45s</span>
              <span className="text-sm font-semibold text-rakshaa-success mb-1">-2m</span>
            </div>
          </div>
          <div className="bg-white border border-rakshaa-border rounded-xl p-6 shadow-sm">
            <h4 className="text-sm font-semibold text-rakshaa-muted uppercase tracking-wider mb-2">New Registrations</h4>
            <div className="flex items-end space-x-3">
              <span className="text-3xl font-bold text-rakshaa-navy">428</span>
              <span className="text-sm font-semibold text-rakshaa-success mb-1">+12%</span>
            </div>
          </div>
          <div className="bg-white border border-rakshaa-border rounded-xl p-6 shadow-sm">
            <h4 className="text-sm font-semibold text-rakshaa-muted uppercase tracking-wider mb-2">Network Expansion</h4>
            <div className="flex items-end space-x-3">
              <span className="text-3xl font-bold text-rakshaa-navy">1,204</span>
              <span className="text-sm text-rakshaa-muted font-medium mb-1">New contacts added</span>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
