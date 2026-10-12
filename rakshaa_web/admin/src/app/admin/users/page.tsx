"use client";

import { motion } from 'framer-motion';
import { 
  Search,
  Filter,
  CheckCircle2,
  XCircle,
  MoreVertical,
  ChevronLeft,
  ChevronRight,
  ShieldAlert
} from 'lucide-react';
import Link from 'next/link';
import { useEffect, useState } from 'react';
import { collection, onSnapshot } from 'firebase/firestore';
import { db } from '@/lib/firebase';

export default function UsersPage() {
  const [users, setUsers] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = onSnapshot(collection(db, 'users'), (snapshot) => {
      const usersData: any[] = [];
      snapshot.forEach((doc) => {
        usersData.push({ id: doc.id, ...doc.data() });
      });
      // Sort by createdAt desc
      usersData.sort((a, b) => {
        const timeA = a.createdAt?.toMillis ? a.createdAt.toMillis() : 0;
        const timeB = b.createdAt?.toMillis ? b.createdAt.toMillis() : 0;
        return timeB - timeA;
      });
      setUsers(usersData);
      setLoading(false);
    });
    
    return () => unsubscribe();
  }, []);
  return (
    <div className="space-y-6 max-w-7xl mx-auto h-full flex flex-col">
      {/* Header & Controls */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 shrink-0">
        <div>
          <h2 className="text-2xl font-bold text-rakshaa-navy">Users</h2>
          <p className="text-rakshaa-muted mt-1 text-sm">Manage users, view safety profiles and status.</p>
        </div>
        
        <div className="flex flex-wrap items-center gap-3">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-rakshaa-muted" size={18} />
            <input 
              type="text" 
              placeholder="Search by name, email, phone..." 
              className="pl-10 pr-4 py-2 w-64 border border-rakshaa-border rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-rakshaa-coral/50 text-sm"
            />
          </div>
          <button className="flex items-center space-x-2 px-4 py-2 bg-white border border-rakshaa-border rounded-lg text-rakshaa-navy font-medium hover:bg-rakshaa-bg transition-colors text-sm">
            <Filter size={16} />
            <span>Filter (0)</span>
          </button>
        </div>
      </div>

      {/* Table */}
      <div className="bg-white border border-rakshaa-border rounded-xl shadow-sm flex-1 flex flex-col overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-rakshaa-bg border-b border-rakshaa-border">
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">User</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Contact</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Safety Status</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Network</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Joined</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Status</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-rakshaa-border">
              {loading ? (
                <tr>
                  <td colSpan={7} className="py-8 text-center text-rakshaa-muted">Loading users...</td>
                </tr>
              ) : users.length > 0 ? (
                users.map(user => {
                  const hasContacts = user.trustedContacts && user.trustedContacts.length > 0;
                  
                  return (
                    <UserRow 
                      key={user.id}
                      id={user.id}
                      name={user.fullName || 'Unknown User'}
                      email={user.email || 'No email'}
                      phone={user.mobileNumber || 'No phone'}
                      safetyStatus={hasContacts ? 'Ready' : 'Incomplete'}
                      contacts={user.trustedContacts?.length || 0}
                      emergencies={user.emergencies || 0}
                      joined={user.createdAt ? (user.createdAt.toDate ? user.createdAt.toDate().toLocaleDateString() : new Date(user.createdAt).toLocaleDateString()) : 'N/A'}
                      status={user.status || 'Active'}
                    />
                  );
                })
              ) : (
                <tr>
                  <td colSpan={7} className="py-12 text-center text-rakshaa-muted">
                    <div className="flex flex-col items-center justify-center">
                      <ShieldAlert size={40} className="text-rakshaa-muted/30 mb-3" />
                      <p className="text-rakshaa-navy font-semibold text-lg">No users found</p>
                      <p className="text-sm">There are currently no registered users in the database.</p>
                    </div>
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
        
        {/* Pagination */}
        <div className="mt-auto border-t border-rakshaa-border p-4 flex items-center justify-between bg-rakshaa-bg/50">
          <p className="text-sm text-rakshaa-muted">Showing <span className="font-semibold text-rakshaa-navy">{users.length > 0 ? 1 : 0}</span> to <span className="font-semibold text-rakshaa-navy">{users.length}</span> of <span className="font-semibold text-rakshaa-navy">{users.length}</span> results</p>
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

function UserRow({ id, name, email, phone, safetyStatus, contacts, emergencies, joined, status }: any) {
  const isReady = safetyStatus === 'Ready';
  const isActive = status === 'Active';

  return (
    <tr className="hover:bg-rakshaa-bg/50 transition-colors group">
      <td className="py-4 px-6">
        <div className="flex items-center space-x-3">
          <div className="w-10 h-10 rounded-full bg-rakshaa-navy text-white flex items-center justify-center font-bold text-sm shrink-0">
            {name.split(' ').map((n: string) => n[0]).join('')}
          </div>
          <div>
            <p className="font-semibold text-rakshaa-navy text-sm">{name}</p>
            {emergencies > 0 && (
              <p className="text-[10px] text-rakshaa-coral flex items-center font-semibold mt-0.5">
                <ShieldAlert size={10} className="mr-1" /> {emergencies} Emergencies
              </p>
            )}
          </div>
        </div>
      </td>
      <td className="py-4 px-6 text-sm text-rakshaa-muted">
        <p className="text-rakshaa-navy font-medium">{phone}</p>
        <p className="text-xs">{email}</p>
      </td>
      <td className="py-4 px-6">
        <div className={`inline-flex items-center px-2.5 py-1 rounded-md text-xs font-semibold ${isReady ? 'bg-rakshaa-success/10 text-rakshaa-success' : 'bg-rakshaa-warning/10 text-rakshaa-warning'}`}>
          {isReady ? <CheckCircle2 size={12} className="mr-1.5" /> : <XCircle size={12} className="mr-1.5" />}
          {safetyStatus}
        </div>
      </td>
      <td className="py-4 px-6 text-sm">
        <p className="text-rakshaa-navy font-medium">{contacts} Contacts</p>
      </td>
      <td className="py-4 px-6 text-sm text-rakshaa-muted">
        {joined}
      </td>
      <td className="py-4 px-6">
        <div className={`inline-flex items-center px-2 py-0.5 rounded text-xs font-semibold ${isActive ? 'bg-gray-100 text-gray-700 border border-gray-200' : 'bg-rakshaa-danger/10 text-rakshaa-danger border border-rakshaa-danger/20'}`}>
          {status}
        </div>
      </td>
      <td className="py-4 px-6 text-right">
        <div className="flex items-center justify-end space-x-2">
          <Link href={`/admin/users/${id}`}>
            <button className="text-rakshaa-coral font-medium text-sm hover:underline">View</button>
          </Link>
          <button className="p-1 text-rakshaa-muted hover:bg-rakshaa-border rounded transition-colors opacity-0 group-hover:opacity-100">
            <MoreVertical size={16} />
          </button>
        </div>
      </td>
    </tr>
  );
}
