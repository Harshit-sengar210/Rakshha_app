"use client";

import { useState, Suspense } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { 
  Shield, 
  LayoutDashboard, 
  Users, 
  AlertTriangle, 
  MapPin, 
  History, 
  Network, 
  MessageCircle, 
  Bell, 
  Wrench, 
  BarChart3, 
  LifeBuoy, 
  FileText, 
  UserCog, 
  Settings,
  Menu,
  ChevronDown,
  LogOut,
  User as UserIcon
} from 'lucide-react';
import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import { auth } from '@/lib/firebase';
import { signOut } from 'firebase/auth';

function AdminLayoutInner({
  children,
}: {
  children: React.ReactNode
}) {
  const [collapsed, setCollapsed] = useState(false);
  const [showDropdown, setShowDropdown] = useState(false);
  const pathname = usePathname();
  const router = useRouter();

  const handleLogout = async () => {
    try {
      await signOut(auth);
      router.push('/login');
    } catch (error) {
      console.error("Error signing out: ", error);
    }
  };

  const navItems = [
    { name: 'Dashboard', path: '/admin', icon: LayoutDashboard },
    { name: 'Users', path: '/admin/users', icon: Users },
    { name: 'Live Emergencies', path: '/admin/emergencies', icon: AlertTriangle },
    { name: 'Live Locations', path: '/admin/locations', icon: MapPin },
    { name: 'Emergency History', path: '/admin/history', icon: History },
    { name: 'Safety Network', path: '/admin/safety-network', icon: Network },
    { name: 'WhatsApp Center', path: '/admin/whatsapp', icon: MessageCircle },
    { name: 'Notifications', path: '/admin/notifications', icon: Bell },
    { name: 'Safety Tools', path: '/admin/safety-tools', icon: Wrench },
    { name: 'Reports & Analytics', path: '/admin/analytics', icon: BarChart3 },
    { name: 'Support', path: '/admin/support', icon: LifeBuoy },
    { name: 'Audit Logs', path: '/admin/audit-logs', icon: FileText },
    { name: 'Admin Management', path: '/admin/admins', icon: UserCog },
    { name: 'Settings', path: '/admin/settings', icon: Settings },
  ];

  return (
    <div className="flex h-screen bg-rakshaa-bg font-sans overflow-hidden">
      {/* Sidebar */}
      <motion.aside 
        animate={{ width: collapsed ? 72 : 260 }}
        transition={{ duration: 0.3, ease: "easeInOut" }}
        className="h-full bg-rakshaa-navy text-white flex flex-col shadow-2xl relative z-20 shrink-0 border-r border-white/5"
      >
        <div className="flex items-center p-6 mb-2">
          <div className="flex items-center justify-center min-w-[32px] h-8 text-rakshaa-coral">
            <Shield size={28} />
          </div>
          <AnimatePresence>
            {!collapsed && (
              <motion.div 
                initial={{ opacity: 0, x: -10 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, x: -10 }}
                className="ml-3 overflow-hidden whitespace-nowrap"
              >
                <h2 className="font-bold text-lg leading-tight tracking-wide">RAKSHAA</h2>
                <p className="text-[10px] text-white/60 tracking-wider font-semibold uppercase">Safety Operations</p>
              </motion.div>
            )}
          </AnimatePresence>
        </div>

        <nav className="flex-1 overflow-y-auto overflow-x-hidden [&::-webkit-scrollbar]:hidden [-ms-overflow-style:none] [scrollbar-width:none] px-3 py-2 space-y-1">
          {navItems.map((item) => {
            const isActive = item.path === '/admin' ? pathname === item.path : pathname?.startsWith(item.path);
            const Icon = item.icon;
            
            return (
              <Link key={item.path} href={item.path}>
                <motion.div
                  whileHover={{ x: collapsed ? 0 : 4 }}
                  className={`relative flex items-center p-3 rounded-lg transition-colors cursor-pointer group ${
                    isActive ? 'bg-rakshaa-coral text-white' : 'text-white/70 hover:bg-white/5 hover:text-white'
                  }`}
                >
                  {isActive && (
                    <motion.div 
                      layoutId="active-nav-indicator"
                      className="absolute left-0 top-1/2 -translate-y-1/2 w-1 h-1/2 bg-white rounded-r-full"
                    />
                  )}
                  <div className="min-w-[24px] flex justify-center">
                    <Icon size={20} strokeWidth={isActive ? 2.5 : 2} />
                  </div>
                  
                  <AnimatePresence>
                    {!collapsed && (
                      <motion.span 
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        className={`ml-3 font-medium whitespace-nowrap text-sm ${isActive ? 'font-semibold' : ''}`}
                      >
                        {item.name}
                      </motion.span>
                    )}
                  </AnimatePresence>
                </motion.div>
              </Link>
            );
          })}
        </nav>
        
        <div className="p-4 border-t border-white/10">
          <button 
            onClick={() => setCollapsed(!collapsed)}
            className="w-full flex items-center justify-center p-2 text-white/50 hover:text-white hover:bg-white/5 rounded-lg transition-colors"
          >
            <Menu size={20} />
          </button>
        </div>
      </motion.aside>

      {/* Main Content */}
      <div className="flex-1 flex flex-col h-full overflow-hidden">
        {/* Top Header */}
        <header className="h-[72px] bg-white border-b border-rakshaa-border flex items-center justify-between px-8 shrink-0 z-10 shadow-sm">
          <div>
            <h1 className="text-xl font-bold text-rakshaa-navy">
              {navItems.find(item => item.path === pathname)?.name || 'Dashboard'}
            </h1>
          </div>
          
          <div className="flex items-center space-x-6">
            <div className="flex items-center space-x-2 text-sm font-medium bg-rakshaa-green/30 text-rakshaa-success px-3 py-1.5 rounded-full">
              <div className="w-2 h-2 rounded-full bg-rakshaa-success animate-pulse" />
              <span>Operational</span>
            </div>
            
            <button className="text-rakshaa-muted hover:text-rakshaa-navy transition-colors relative">
              <Bell size={20} />
              <span className="absolute top-0 right-0 w-2 h-2 bg-rakshaa-coral rounded-full" />
            </button>
            
            <div className="h-6 w-px bg-rakshaa-border" />
            
            <div className="relative">
              <div 
                onClick={() => setShowDropdown(!showDropdown)}
                className="flex items-center space-x-3 cursor-pointer hover:opacity-80 transition-opacity"
              >
                <div className="w-9 h-9 rounded-full bg-rakshaa-navy flex items-center justify-center text-white font-bold text-sm">
                  A
                </div>
                <div className="hidden md:block text-sm">
                  <p className="font-bold text-rakshaa-navy">Admin User</p>
                  <p className="text-xs text-rakshaa-muted">Safety Operator</p>
                </div>
                <ChevronDown size={16} className={`text-rakshaa-muted hidden md:block transition-transform ${showDropdown ? 'rotate-180' : ''}`} />
              </div>

              {/* Profile Dropdown */}
              <AnimatePresence>
                {showDropdown && (
                  <>
                    <div className="fixed inset-0 z-40" onClick={() => setShowDropdown(false)} />
                    <motion.div 
                      initial={{ opacity: 0, y: 10, scale: 0.95 }}
                      animate={{ opacity: 1, y: 0, scale: 1 }}
                      exit={{ opacity: 0, y: 10, scale: 0.95 }}
                      transition={{ duration: 0.15 }}
                      className="absolute right-0 top-full mt-2 w-56 bg-white border border-rakshaa-border rounded-xl shadow-lg py-2 z-50 overflow-hidden"
                    >
                      <div className="px-4 py-2 border-b border-rakshaa-border mb-2">
                        <p className="text-sm font-bold text-rakshaa-navy">Signed in as</p>
                        <p className="text-xs text-rakshaa-muted truncate">admin@rakshaa.app</p>
                      </div>
                      
                      <Link href="/admin/settings">
                        <button className="w-full text-left px-4 py-2 text-sm text-rakshaa-navy hover:bg-rakshaa-bg transition-colors flex items-center">
                          <UserIcon size={16} className="mr-3 text-rakshaa-muted" />
                          Profile Settings
                        </button>
                      </Link>
                      
                      <div className="my-2 h-px bg-rakshaa-border" />
                      
                      <button 
                        onClick={handleLogout}
                        className="w-full text-left px-4 py-2 text-sm text-rakshaa-danger hover:bg-rakshaa-danger/10 transition-colors flex items-center font-medium"
                      >
                        <LogOut size={16} className="mr-3 shrink-0" />
                        Sign Out
                      </button>
                    </motion.div>
                  </>
                )}
              </AnimatePresence>
            </div>
          </div>
        </header>

        {/* Page Content */}
        <main className="flex-1 overflow-y-auto p-8 [&::-webkit-scrollbar]:hidden [-ms-overflow-style:none] [scrollbar-width:none]">
          {/* Animated Page Transitions */}
          <AnimatePresence>
            <motion.div
              key={pathname}
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ duration: 0.2 }}
              className="h-full"
            >
              {children}
            </motion.div>
          </AnimatePresence>
        </main>
      </div>
    </div>
  );
}

export default function AdminLayout({ children }: { children: React.ReactNode }) {
  return (
    <Suspense fallback={<div className="flex h-screen bg-rakshaa-bg font-sans overflow-hidden" />}>
      <AdminLayoutInner>{children}</AdminLayoutInner>
    </Suspense>
  );
}
