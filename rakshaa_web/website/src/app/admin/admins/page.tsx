"use client";

import { motion } from 'framer-motion';
import { 
  UserCog,
  Search,
  UserPlus,
  ShieldAlert,
  MoreVertical,
  CheckCircle2,
  Mail,
  Shield,
  Edit,
  Trash2
} from 'lucide-react';
import { useState } from 'react';

export default function AdminManagementPage() {
  return (
    <div className="space-y-6 max-w-7xl mx-auto h-full flex flex-col">
      {/* Header & Controls */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 shrink-0">
        <div>
          <h2 className="text-2xl font-bold text-rakshaa-navy flex items-center">
            <UserCog className="mr-2 text-rakshaa-muted" size={24} />
            Admin Management
          </h2>
          <p className="text-rakshaa-muted mt-1 text-sm">Manage dashboard access, roles, and administrative permissions.</p>
        </div>
        
        <div className="flex items-center gap-3">
          <div className="relative hidden sm:block">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-rakshaa-muted" size={16} />
            <input 
              type="text" 
              placeholder="Search by name or email..." 
              className="pl-9 pr-4 py-2 w-64 border border-rakshaa-border rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-rakshaa-coral/50 text-sm"
            />
          </div>
          <button className="flex items-center space-x-2 px-4 py-2 bg-rakshaa-coral text-white rounded-lg font-bold hover:bg-rakshaa-coral/90 transition-colors text-sm shadow-sm">
            <UserPlus size={16} />
            <span>Invite Admin</span>
          </button>
        </div>
      </div>

      {/* KPI Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 shrink-0">
        <div className="bg-white p-5 rounded-xl border border-rakshaa-border shadow-sm flex items-center">
          <div className="w-12 h-12 bg-rakshaa-navy/10 text-rakshaa-navy rounded-full flex items-center justify-center mr-4">
            <Shield size={24} />
          </div>
          <div>
            <p className="text-rakshaa-muted text-xs font-semibold uppercase">Total Active Admins</p>
            <p className="text-2xl font-bold text-rakshaa-navy mt-0.5">14</p>
          </div>
        </div>
        
        <div className="bg-white p-5 rounded-xl border border-rakshaa-border shadow-sm flex items-center">
          <div className="w-12 h-12 bg-rakshaa-warning/10 text-rakshaa-warning rounded-full flex items-center justify-center mr-4">
            <Mail size={24} />
          </div>
          <div>
            <p className="text-rakshaa-muted text-xs font-semibold uppercase">Pending Invitations</p>
            <p className="text-2xl font-bold text-rakshaa-navy mt-0.5">2</p>
          </div>
        </div>
        
        <div className="bg-white p-5 rounded-xl border border-rakshaa-border shadow-sm flex items-center">
          <div className="w-12 h-12 bg-rakshaa-danger/10 text-rakshaa-danger rounded-full flex items-center justify-center mr-4">
            <ShieldAlert size={24} />
          </div>
          <div>
            <p className="text-rakshaa-muted text-xs font-semibold uppercase">Suspended Accounts</p>
            <p className="text-2xl font-bold text-rakshaa-navy mt-0.5">3</p>
          </div>
        </div>
      </div>

      {/* Admin Table */}
      <div className="bg-white border border-rakshaa-border rounded-xl shadow-sm flex-1 flex flex-col overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-rakshaa-bg border-b border-rakshaa-border">
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Admin Details</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Role</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Status</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Last Active</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-rakshaa-border">
              
              <AdminRow 
                name="System Administrator"
                email="admin.super@rakshaa.app"
                role="Super Admin"
                status="Active"
                lastActive="Just now"
                avatarColor="bg-rakshaa-navy"
              />
              <AdminRow 
                name="Amit Patel"
                email="amit.patel@rakshaa.app"
                role="Support Manager"
                status="Active"
                lastActive="15 mins ago"
                avatarColor="bg-blue-600"
              />
              <AdminRow 
                name="Neha Sharma"
                email="neha.sharma@rakshaa.app"
                role="Support Agent"
                status="Active"
                lastActive="1 hour ago"
                avatarColor="bg-rakshaa-coral"
              />
              <AdminRow 
                name="Vikram Singh"
                email="vikram.s@rakshaa.app"
                role="Technical Operations"
                status="Active"
                lastActive="3 hours ago"
                avatarColor="bg-purple-600"
              />
              <AdminRow 
                name="Priya Desai"
                email="priya.desai@rakshaa.app"
                role="Support Agent"
                status="Suspended"
                lastActive="2 months ago"
                avatarColor="bg-gray-400"
              />
              <AdminRow 
                name="Rahul Verma"
                email="rahul.verma@rakshaa.app"
                role="Support Agent"
                status="Pending"
                lastActive="Never"
                avatarColor="bg-rakshaa-warning"
              />

            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

function AdminRow({ name, email, role, status, lastActive, avatarColor }: any) {
  let StatusIcon = CheckCircle2;
  let statusBadgeClass = "";
  
  if (status === 'Active') {
    statusBadgeClass = "bg-rakshaa-success/10 text-rakshaa-success border-rakshaa-success/20";
    StatusIcon = CheckCircle2;
  } else if (status === 'Suspended') {
    statusBadgeClass = "bg-rakshaa-danger/10 text-rakshaa-danger border-rakshaa-danger/20";
    StatusIcon = ShieldAlert;
  } else if (status === 'Pending') {
    statusBadgeClass = "bg-rakshaa-warning/10 text-rakshaa-warning border-rakshaa-warning/20";
    StatusIcon = Mail;
  }

  let roleClass = "bg-gray-100 text-gray-700";
  if (role === 'Super Admin') roleClass = "bg-rakshaa-navy text-white shadow-sm";
  if (role === 'Support Manager') roleClass = "bg-blue-100 text-blue-700";
  if (role === 'Support Agent') roleClass = "bg-rakshaa-success/10 text-rakshaa-success";
  if (role === 'Technical Operations') roleClass = "bg-purple-100 text-purple-700";

  return (
    <tr className="hover:bg-rakshaa-bg/50 transition-colors group">
      <td className="py-4 px-6">
        <div className="flex items-center space-x-3">
          <div className={`w-10 h-10 rounded-full flex items-center justify-center text-white font-bold shadow-sm ${avatarColor}`}>
            {name.split(' ').map((n: string) => n[0]).join('').substring(0, 2)}
          </div>
          <div>
            <p className="font-bold text-rakshaa-navy text-sm">{name}</p>
            <p className="text-xs text-rakshaa-muted">{email}</p>
          </div>
        </div>
      </td>
      <td className="py-4 px-6">
        <span className={`px-2.5 py-1 rounded-md text-[11px] font-bold uppercase tracking-wider ${roleClass}`}>
          {role}
        </span>
      </td>
      <td className="py-4 px-6">
        <div className={`inline-flex items-center px-2 py-1 rounded-md text-[10px] font-bold uppercase tracking-wider border ${statusBadgeClass}`}>
          <StatusIcon size={12} className="mr-1.5" />
          {status}
        </div>
      </td>
      <td className="py-4 px-6 text-sm text-rakshaa-muted">
        {lastActive}
      </td>
      <td className="py-4 px-6 text-right">
        <div className="flex items-center justify-end space-x-2">
          <button className="text-blue-500 hover:bg-blue-50 p-2 rounded transition-colors" title="Edit Admin">
            <Edit size={16} />
          </button>
          {role !== 'Super Admin' && (
            <button className="text-rakshaa-danger hover:bg-rakshaa-danger/10 p-2 rounded transition-colors" title="Revoke Access">
              <Trash2 size={16} />
            </button>
          )}
        </div>
      </td>
    </tr>
  );
}
