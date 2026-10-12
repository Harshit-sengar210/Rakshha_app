"use client";

import { motion } from 'framer-motion';
import { 
  MapPin,
  Search,
  Filter,
  Navigation,
  Clock,
  ShieldAlert
} from 'lucide-react';

export default function LiveLocationsPage() {
  return (
    <div className="h-full flex flex-col space-y-4">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 shrink-0">
        <div>
          <h2 className="text-2xl font-bold text-rakshaa-navy flex items-center">
            Live Locations
            <span className="ml-3 bg-rakshaa-coral/10 text-rakshaa-coral text-xs px-2 py-1 rounded-md font-bold uppercase tracking-wider">
              Restricted Data
            </span>
          </h2>
          <p className="text-rakshaa-muted mt-1 text-sm">Showing authorized live tracking for active emergency sessions.</p>
        </div>
        
        <div className="flex items-center space-x-3">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-rakshaa-muted" size={16} />
            <input 
              type="text" 
              placeholder="Search user..." 
              className="pl-9 pr-4 py-1.5 border border-rakshaa-border rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-rakshaa-coral/50 text-sm"
            />
          </div>
          <button className="flex items-center space-x-2 px-3 py-1.5 bg-white border border-rakshaa-border rounded-lg text-rakshaa-navy font-medium hover:bg-rakshaa-bg transition-colors text-sm">
            <Filter size={16} />
            <span>Filter</span>
          </button>
        </div>
      </div>

      {/* Main Layout */}
      <div className="flex-1 flex flex-col lg:flex-row gap-6 overflow-hidden">
        
        {/* Left Side Panel (List) */}
        <div className="w-full lg:w-80 bg-white border border-rakshaa-border rounded-xl shadow-sm flex flex-col overflow-hidden shrink-0">
          <div className="p-4 border-b border-rakshaa-border bg-rakshaa-bg/50 flex justify-between items-center">
            <h3 className="font-bold text-rakshaa-navy text-sm uppercase tracking-wide">Active Tracking</h3>
            <span className="text-xs font-bold text-rakshaa-coral">2 LIVE</span>
          </div>
          
          <div className="flex-1 overflow-y-auto">
            {/* List Item 1 */}
            <div className="p-4 border-b border-rakshaa-border hover:bg-rakshaa-bg transition-colors cursor-pointer border-l-4 border-l-rakshaa-coral bg-rakshaa-coral/5">
              <div className="flex justify-between items-start mb-2">
                <h4 className="font-bold text-rakshaa-navy">Priya Sharma</h4>
                <div className="flex items-center text-[10px] font-bold text-rakshaa-success bg-rakshaa-success/10 px-1.5 py-0.5 rounded uppercase">
                  <span className="w-1.5 h-1.5 bg-rakshaa-success rounded-full mr-1 animate-pulse" /> LIVE
                </div>
              </div>
              <p className="text-sm font-medium text-rakshaa-navy flex items-center mb-1 truncate">
                <MapPin size={12} className="mr-1.5 text-rakshaa-coral" /> Sector 62, Noida
              </p>
              <div className="flex items-center justify-between text-xs text-rakshaa-muted mt-2">
                <span className="flex items-center"><Clock size={12} className="mr-1" /> 5s ago</span>
                <span className="flex items-center text-rakshaa-danger font-medium"><ShieldAlert size={12} className="mr-1" /> EM-10492</span>
              </div>
            </div>

            {/* List Item 2 */}
            <div className="p-4 border-b border-rakshaa-border hover:bg-rakshaa-bg transition-colors cursor-pointer border-l-4 border-l-transparent">
              <div className="flex justify-between items-start mb-2">
                <h4 className="font-bold text-rakshaa-navy">Ananya Singh</h4>
                <div className="flex items-center text-[10px] font-bold text-rakshaa-success bg-rakshaa-success/10 px-1.5 py-0.5 rounded uppercase">
                  <span className="w-1.5 h-1.5 bg-rakshaa-success rounded-full mr-1 animate-pulse" /> LIVE
                </div>
              </div>
              <p className="text-sm font-medium text-rakshaa-navy flex items-center mb-1 truncate">
                <MapPin size={12} className="mr-1.5 text-rakshaa-coral" /> Indirapuram, Ghaziabad
              </p>
              <div className="flex items-center justify-between text-xs text-rakshaa-muted mt-2">
                <span className="flex items-center"><Clock size={12} className="mr-1" /> 12s ago</span>
                <span className="flex items-center text-rakshaa-danger font-medium"><ShieldAlert size={12} className="mr-1" /> EM-10493</span>
              </div>
            </div>
            
          </div>
        </div>

        {/* Right Side Map */}
        <div className="flex-1 bg-rakshaa-bg border border-rakshaa-border rounded-xl relative overflow-hidden flex items-center justify-center shadow-sm">
          {/* Map Grid Pattern */}
          <div className="absolute inset-0 opacity-10" 
               style={{ backgroundImage: 'linear-gradient(to right, #172B4D 1px, transparent 1px), linear-gradient(to bottom, #172B4D 1px, transparent 1px)', backgroundSize: '60px 60px' }} 
          />
          
          <div className="text-center z-10 p-6 bg-white/90 backdrop-blur rounded-2xl shadow-lg border border-white max-w-sm">
            <Navigation size={48} className="mx-auto text-rakshaa-navy mb-4 opacity-20" />
            <h3 className="font-bold text-rakshaa-navy text-xl">Interactive Map Area</h3>
            <p className="text-sm text-rakshaa-muted mt-2 mb-4">Integrate Google Maps or Mapbox here to track markers in real-time.</p>
            <div className="bg-rakshaa-coral/10 text-rakshaa-coral p-3 rounded-lg flex items-center text-sm font-medium">
              <ShieldAlert size={16} className="mr-2 shrink-0" />
              Showing 2 authorized emergency locations.
            </div>
          </div>
          
          {/* Mock Marker 1 */}
          <motion.div 
            animate={{ scale: [1, 1.4, 1], opacity: [0.3, 0, 0.3] }}
            transition={{ repeat: Infinity, duration: 2 }}
            className="absolute top-1/4 left-1/4 w-40 h-40 bg-rakshaa-coral rounded-full"
          />
          <div className="absolute top-1/4 left-1/4 w-6 h-6 bg-rakshaa-coral border-4 border-white rounded-full shadow-lg transform -translate-x-1/2 -translate-y-1/2 z-20">
            <div className="absolute -top-10 -left-12 bg-white px-3 py-1 rounded shadow-md text-xs font-bold text-rakshaa-navy whitespace-nowrap">
              Priya S.
            </div>
          </div>

          {/* Map Controls */}
          <div className="absolute bottom-6 right-6 flex flex-col space-y-2 z-20">
            <button className="w-10 h-10 bg-white border border-rakshaa-border rounded-lg shadow-sm flex items-center justify-center text-rakshaa-navy hover:bg-rakshaa-bg transition-colors font-bold text-xl">+</button>
            <button className="w-10 h-10 bg-white border border-rakshaa-border rounded-lg shadow-sm flex items-center justify-center text-rakshaa-navy hover:bg-rakshaa-bg transition-colors font-bold text-xl">-</button>
          </div>
        </div>

      </div>
    </div>
  );
}
