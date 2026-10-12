"use client";

import { motion } from 'framer-motion';
import { 
  FileText,
  Search,
  Filter,
  Download,
  AlertTriangle,
  UserCheck,
  Settings,
  Shield,
  ChevronLeft,
  ChevronRight
} from 'lucide-react';

export default function AuditLogsPage() {
  return (
    <div className="space-y-6 max-w-7xl mx-auto h-full flex flex-col">
      {/* Header & Controls */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 shrink-0">
        <div>
          <h2 className="text-2xl font-bold text-rakshaa-navy flex items-center">
            <FileText className="mr-2 text-rakshaa-muted" size={24} />
            System Audit Logs
          </h2>
          <p className="text-rakshaa-muted mt-1 text-sm">Comprehensive record of all administrative and system-level actions.</p>
        </div>
        
        <div className="flex items-center gap-3">
          <div className="relative hidden sm:block">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-rakshaa-muted" size={16} />
            <input 
              type="text" 
              placeholder="Search by action or admin..." 
              className="pl-9 pr-4 py-2 w-64 border border-rakshaa-border rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-rakshaa-coral/50 text-sm"
            />
          </div>
          <button className="flex items-center space-x-2 px-3 py-2 bg-white border border-rakshaa-border rounded-lg text-rakshaa-navy font-medium hover:bg-rakshaa-bg transition-colors text-sm shadow-sm">
            <Filter size={16} />
            <span>Filter</span>
          </button>
          <button className="flex items-center space-x-2 px-3 py-2 bg-rakshaa-navy text-white rounded-lg font-medium hover:bg-rakshaa-navy/90 transition-colors text-sm shadow-sm">
            <Download size={16} />
            <span>Export CSV</span>
          </button>
        </div>
      </div>

      {/* Audit Log Table */}
      <div className="bg-white border border-rakshaa-border rounded-xl shadow-sm flex-1 flex flex-col overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-rakshaa-bg border-b border-rakshaa-border">
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Timestamp</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Action Type</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Description</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Performed By</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">IP Address</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-rakshaa-border">
              
              <LogRow 
                timestamp="08 Oct 2026, 13:05:12"
                type="security"
                action="Admin Login Success"
                description="Successful login via two-factor authentication."
                actor="amit.patel@rakshaa.app"
                ip="192.168.1.45"
              />
              <LogRow 
                timestamp="08 Oct 2026, 12:42:05"
                type="support"
                action="Ticket Resolved"
                description="Ticket #TKT-9041 marked as resolved."
                actor="neha.sharma@rakshaa.app"
                ip="10.0.0.214"
              />
              <LogRow 
                timestamp="08 Oct 2026, 11:15:33"
                type="system"
                action="WhatsApp Webhook Sync"
                description="Automated synchronization of delivery receipts."
                actor="System Account"
                ip="AWS us-east-1"
              />
              <LogRow 
                timestamp="08 Oct 2026, 09:30:00"
                type="alert"
                action="Failed Login Attempt"
                description="3 consecutive failed login attempts detected."
                actor="unknown@rakshaa.app"
                ip="45.22.109.81"
              />
              <LogRow 
                timestamp="07 Oct 2026, 18:20:11"
                type="config"
                action="API Key Rotated"
                description="Twilio SMS integration API key rotated."
                actor="admin.super@rakshaa.app"
                ip="192.168.1.10"
              />
              <LogRow 
                timestamp="07 Oct 2026, 14:05:42"
                type="support"
                action="Emergency Record Accessed"
                description="Viewed emergency history for RK-EM-10488."
                actor="amit.patel@rakshaa.app"
                ip="192.168.1.45"
              />

            </tbody>
          </table>
        </div>
        
        {/* Pagination */}
        <div className="mt-auto border-t border-rakshaa-border p-4 flex items-center justify-between bg-rakshaa-bg/50">
          <p className="text-sm text-rakshaa-muted">Showing <span className="font-semibold text-rakshaa-navy">1</span> to <span className="font-semibold text-rakshaa-navy">6</span> of <span className="font-semibold text-rakshaa-navy">14,204</span> logs</p>
          <div className="flex items-center space-x-2">
            <button className="p-1 border border-rakshaa-border rounded bg-white text-rakshaa-muted hover:text-rakshaa-navy disabled:opacity-50" disabled>
              <ChevronLeft size={18} />
            </button>
            <button className="px-3 py-1 border border-rakshaa-coral bg-rakshaa-coral/10 text-rakshaa-coral rounded text-sm font-medium">1</button>
            <button className="px-3 py-1 border border-transparent hover:bg-rakshaa-border rounded text-sm text-rakshaa-muted font-medium">2</button>
            <button className="px-3 py-1 border border-transparent hover:bg-rakshaa-border rounded text-sm text-rakshaa-muted font-medium">3</button>
            <span className="text-rakshaa-muted">...</span>
            <button className="p-1 border border-rakshaa-border rounded bg-white text-rakshaa-muted hover:text-rakshaa-navy">
              <ChevronRight size={18} />
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

function LogRow({ timestamp, type, action, description, actor, ip }: any) {
  let TypeIcon = Settings;
  let typeColor = "bg-gray-100 text-gray-600 border-gray-200";

  if (type === 'security') {
    TypeIcon = Shield;
    typeColor = "bg-blue-50 text-blue-600 border-blue-200";
  } else if (type === 'alert') {
    TypeIcon = AlertTriangle;
    typeColor = "bg-rakshaa-danger/10 text-rakshaa-danger border-rakshaa-danger/20";
  } else if (type === 'support') {
    TypeIcon = UserCheck;
    typeColor = "bg-rakshaa-success/10 text-rakshaa-success border-rakshaa-success/20";
  } else if (type === 'system') {
    TypeIcon = Settings;
    typeColor = "bg-purple-50 text-purple-600 border-purple-200";
  } else if (type === 'config') {
    TypeIcon = Settings;
    typeColor = "bg-rakshaa-warning/10 text-rakshaa-warning border-rakshaa-warning/20";
  }

  return (
    <tr className="hover:bg-rakshaa-bg/50 transition-colors">
      <td className="py-4 px-6 text-sm font-mono text-rakshaa-muted whitespace-nowrap">
        {timestamp}
      </td>
      <td className="py-4 px-6">
        <div className={`inline-flex items-center px-2 py-1 rounded-md text-[10px] font-bold uppercase tracking-wider border ${typeColor}`}>
          <TypeIcon size={12} className="mr-1.5" />
          {type}
        </div>
      </td>
      <td className="py-4 px-6">
        <p className="font-semibold text-rakshaa-navy text-sm">{action}</p>
        <p className="text-xs text-rakshaa-muted mt-0.5">{description}</p>
      </td>
      <td className="py-4 px-6 text-sm font-medium text-rakshaa-navy">
        {actor}
      </td>
      <td className="py-4 px-6 text-sm font-mono text-rakshaa-muted">
        {ip}
      </td>
    </tr>
  );
}
