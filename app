import React, { useState } from 'react';
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Link,
} from 'react-router-dom';
import { v4 as uuidv4 } from 'uuid';

// Main App component
const App = () => {
  const [activeTab, setActiveTab] = useState('flocks');

  return (
    <div className="min-h-screen bg-gray-100 p-8 font-sans">
      <header className="mb-8">
        <h1 className="text-4xl font-bold text-center text-gray-800">Hatchery Database</h1>
        <p className="text-center text-gray-600 mt-2">Manage your flock, incubation, hatchery, and sales records.</p>
      </header>

      <div className="bg-white rounded-xl shadow-lg p-6">
        <nav className="flex space-x-4 border-b border-gray-200 mb-6">
          <TabButton name="flocks" activeTab={activeTab} setActiveTab={setActiveTab}>
            Flock Records
          </TabButton>
          <TabButton name="incubation" activeTab={activeTab} setActiveTab={setActiveTab}>
            Incubation Log
          </TabButton>
          <TabButton name="hatchery" activeTab={activeTab} setActiveTab={setActiveTab}>
            Hatchery Log
          </TabButton>
          <TabButton name="chickSales" activeTab={activeTab} setActiveTab={setActiveTab}>
            Chick Sales
          </TabButton>
          <TabButton name="eggSales" activeTab={activeTab} setActiveTab={setActiveTab}>
            Egg Sales
          </TabButton>
        </nav>

        <main>
          {activeTab === 'flocks' && <FlockRecords />}
          {activeTab === 'incubation' && <IncubationLog />}
          {activeTab === 'hatchery' && <HatcheryLog />}
          {activeTab === 'chickSales' && <ChickSales />}
          {activeTab === 'eggSales' && <EggSales />}
        </main>
      </div>
    </div>
  );
};

// Reusable Tab Button Component
const TabButton = ({ name, activeTab, setActiveTab, children }) => {
  const isActive = name === activeTab;
  const activeClasses = 'border-indigo-600 text-indigo-600';
  const inactiveClasses = 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300';
  
  return (
    <button
      onClick={() => setActiveTab(name)}
      className={`py-2 px-4 font-medium text-sm transition-colors duration-200 border-b-2 ${isActive ? activeClasses : inactiveClasses}`}
    >
      {children}
    </button>
  );
};

// Flock Records Component
const FlockRecords = () => {
  const [flocks, setFlocks] = useState([]);
  const [form, setForm] = useState({ id: '', established: '', hens: '', roosters: '', eggProduction: '', mortality: '', ptTestDate: '', ptTestResult: '', notes: '' });
  const [editingId, setEditingId] = useState(null);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setForm({ ...form, [name]: value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (editingId) {
      setFlocks(flocks.map(flock => flock.id === editingId ? { ...flock, ...form } : flock));
      setEditingId(null);
    } else {
      setFlocks([...flocks, { ...form, id: uuidv4() }]);
    }
    setForm({ id: '', established: '', hens: '', roosters: '', eggProduction: '', mortality: '', ptTestDate: '', ptTestResult: '', notes: '' });
  };

  const handleEdit = (flock) => {
    setForm(flock);
    setEditingId(flock.id);
  };

  const handleDelete = (id) => {
    setFlocks(flocks.filter(flock => flock.id !== id));
  };

  const renderTable = (data, headers, handleEdit, handleDelete) => {
    if (data.length === 0) {
      return <p className="text-gray-500 text-center">No records to display. Add a new one using the form above.</p>;
    }
    return (
      <div className="overflow-x-auto mt-6">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              {headers.map((header) => (
                <th key={header.key} scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  {header.label}
                </th>
              ))}
              <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {data.map((item) => (
              <tr key={item.id}>
                {headers.map((header) => (
                  <td key={header.key} className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {item[header.key]}
                  </td>
                ))}
                <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                  <button onClick={() => handleEdit(item)} className="text-indigo-600 hover:text-indigo-900 mr-4">Edit</button>
                  <button onClick={() => handleDelete(item.id)} className="text-red-600 hover:text-red-900">Delete</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  };

  const headers = [
    { key: 'id', label: 'Flock ID' },
    { key: 'established', label: 'Date Established' },
    { key: 'hens', label: 'Number of Hens' },
    { key: 'roosters', label: 'Number of Roosters' },
    { key: 'eggProduction', label: 'Weekly Egg Production' },
    { key: 'mortality', label: 'Weekly Mortality' },
    { key: 'ptTestDate', label: 'Last PT Test Date' },
    { key: 'ptTestResult', label: 'PT Test Result' },
    { key: 'notes', label: 'Notes' },
  ];

  const formFields = [
    { name: 'id', label: 'Flock ID', type: 'text' },
    { name: 'established', label: 'Date Established', type: 'date' },
    { name: 'hens', label: 'Number of Hens', type: 'number' },
    { name: 'roosters', label: 'Number of Roosters', type: 'number' },
    { name: 'eggProduction', label: 'Weekly Egg Production', type: 'number' },
    { name: 'mortality', label: 'Weekly Mortality', type: 'number' },
    { name: 'ptTestDate', label: 'Last PT Test Date', type: 'date' },
    { name: 'ptTestResult', label: 'PT Test Result', type: 'text' },
    { name: 'notes', label: 'Notes', type: 'textarea' },
  ];

  return (
    <div>
      <h2 className="text-2xl font-semibold text-gray-700 mb-4">Flock Records</h2>
      <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 bg-gray-50 p-6 rounded-lg shadow-inner">
        {formFields.map(field => (
          <div key={field.name}>
            <label className="block text-sm font-medium text-gray-700">{field.label}</label>
            {field.type === 'textarea' ? (
              <textarea
                name={field.name}
                value={form[field.name]}
                onChange={handleInputChange}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
              />
            ) : (
              <input
                type={field.type}
                name={field.name}
                value={form[field.name]}
                onChange={handleInputChange}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
              />
            )}
          </div>
        ))}
        <div className="md:col-span-2 lg:col-span-3">
          <button
            type="submit"
            className="w-full inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            {editingId ? 'Update Record' : 'Add Record'}
          </button>
        </div>
      </form>
      {renderTable(flocks, headers, handleEdit, handleDelete)}
    </div>
  );
};

// Incubation Log Component
const IncubationLog = () => {
  const [incubationRecords, setIncubationRecords] = useState([]);
  const [form, setForm] = useState({ id: '', dateCollected: '', flockId: '', numEggs: '', dateSet: '', incubatorId: '', targetHatchDate: '', notes: '' });
  const [editingId, setEditingId] = useState(null);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setForm({ ...form, [name]: value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (editingId) {
      setIncubationRecords(incubationRecords.map(rec => rec.id === editingId ? { ...rec, ...form } : rec));
      setEditingId(null);
    } else {
      setIncubationRecords([...incubationRecords, { ...form, id: uuidv4() }]);
    }
    setForm({ id: '', dateCollected: '', flockId: '', numEggs: '', dateSet: '', incubatorId: '', targetHatchDate: '', notes: '' });
  };

  const handleEdit = (record) => {
    setForm(record);
    setEditingId(record.id);
  };

  const handleDelete = (id) => {
    setIncubationRecords(incubationRecords.filter(rec => rec.id !== id));
  };
  
  const renderTable = (data, headers, handleEdit, handleDelete) => {
    if (data.length === 0) {
      return <p className="text-gray-500 text-center">No records to display. Add a new one using the form above.</p>;
    }
    return (
      <div className="overflow-x-auto mt-6">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              {headers.map((header) => (
                <th key={header.key} scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  {header.label}
                </th>
              ))}
              <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {data.map((item) => (
              <tr key={item.id}>
                {headers.map((header) => (
                  <td key={header.key} className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {item[header.key]}
                  </td>
                ))}
                <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                  <button onClick={() => handleEdit(item)} className="text-indigo-600 hover:text-indigo-900 mr-4">Edit</button>
                  <button onClick={() => handleDelete(item.id)} className="text-red-600 hover:text-red-900">Delete</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  };
  
  const headers = [
    { key: 'dateCollected', label: 'Date Collected' },
    { key: 'flockId', label: 'Flock ID' },
    { key: 'numEggs', label: 'Number of Eggs' },
    { key: 'dateSet', label: 'Date Set' },
    { key: 'incubatorId', label: 'Incubator ID' },
    { key: 'targetHatchDate', label: 'Target Hatch Date' },
    { key: 'notes', label: 'Notes' },
  ];
  
  const formFields = [
    { name: 'dateCollected', label: 'Date Collected', type: 'date' },
    { name: 'flockId', label: 'Flock ID', type: 'text' },
    { name: 'numEggs', label: 'Number of Eggs', type: 'number' },
    { name: 'dateSet', label: 'Date Set', type: 'date' },
    { name: 'incubatorId', label: 'Incubator ID', type: 'text' },
    { name: 'targetHatchDate', label: 'Target Hatch Date', type: 'date' },
    { name: 'notes', label: 'Notes', type: 'textarea' },
  ];
  
  return (
    <div>
      <h2 className="text-2xl font-semibold text-gray-700 mb-4">Incubation Log</h2>
      <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 bg-gray-50 p-6 rounded-lg shadow-inner">
        {formFields.map(field => (
          <div key={field.name}>
            <label className="block text-sm font-medium text-gray-700">{field.label}</label>
            {field.type === 'textarea' ? (
              <textarea
                name={field.name}
                value={form[field.name]}
                onChange={handleInputChange}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
              />
            ) : (
              <input
                type={field.type}
                name={field.name}
                value={form[field.name]}
                onChange={handleInputChange}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
              />
            )}
          </div>
        ))}
        <div className="md:col-span-2 lg:col-span-3">
          <button
            type="submit"
            className="w-full inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            {editingId ? 'Update Record' : 'Add Record'}
          </button>
        </div>
      </form>
      {renderTable(incubationRecords, headers, handleEdit, handleDelete)}
    </div>
  );
};

// Hatchery Log Component
const HatcheryLog = () => {
  const [hatcheryRecords, setHatcheryRecords] = useState([]);
  const [form, setForm] = useState({ id: '', hatchDate: '', incubatorId: '', totalEggsSet: '', numHatched: '', infertile: '', deadInShell: '', hatchRate: '', notes: '' });
  const [editingId, setEditingId] = useState(null);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setForm({ ...form, [name]: value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    const hatchRate = form.totalEggsSet > 0 ? ((form.numHatched / form.totalEggsSet) * 100).toFixed(2) + '%' : '0.00%';
    const newRecord = { ...form, hatchRate };
    
    if (editingId) {
      setHatcheryRecords(hatcheryRecords.map(rec => rec.id === editingId ? { ...rec, ...newRecord } : rec));
      setEditingId(null);
    } else {
      setHatcheryRecords([...hatcheryRecords, { ...newRecord, id: uuidv4() }]);
    }
    setForm({ id: '', hatchDate: '', incubatorId: '', totalEggsSet: '', numHatched: '', infertile: '', deadInShell: '', hatchRate: '', notes: '' });
  };

  const handleEdit = (record) => {
    setForm(record);
    setEditingId(record.id);
  };

  const handleDelete = (id) => {
    setHatcheryRecords(hatcheryRecords.filter(rec => rec.id !== id));
  };

  const renderTable = (data, headers, handleEdit, handleDelete) => {
    if (data.length === 0) {
      return <p className="text-gray-500 text-center">No records to display. Add a new one using the form above.</p>;
    }
    return (
      <div className="overflow-x-auto mt-6">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              {headers.map((header) => (
                <th key={header.key} scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  {header.label}
                </th>
              ))}
              <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {data.map((item) => (
              <tr key={item.id}>
                {headers.map((header) => (
                  <td key={header.key} className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {item[header.key]}
                  </td>
                ))}
                <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                  <button onClick={() => handleEdit(item)} className="text-indigo-600 hover:text-indigo-900 mr-4">Edit</button>
                  <button onClick={() => handleDelete(item.id)} className="text-red-600 hover:text-red-900">Delete</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  };
  
  const headers = [
    { key: 'hatchDate', label: 'Hatch Date' },
    { key: 'incubatorId', label: 'Incubator ID' },
    { key: 'totalEggsSet', label: 'Total Eggs Set' },
    { key: 'numHatched', label: 'Number Hatched' },
    { key: 'infertile', label: 'Infertile/Clear' },
    { key: 'deadInShell', label: 'Dead-in-shell' },
    { key: 'hatchRate', label: 'Hatch Rate %' },
    { key: 'notes', label: 'Notes' },
  ];

  const formFields = [
    { name: 'hatchDate', label: 'Hatch Date', type: 'date' },
    { name: 'incubatorId', label: 'Incubator ID', type: 'text' },
    { name: 'totalEggsSet', label: 'Total Eggs Set', type: 'number' },
    { name: 'numHatched', label: 'Number Hatched', type: 'number' },
    { name: 'infertile', label: 'Infertile/Clear', type: 'number' },
    { name: 'deadInShell', label: 'Dead-in-shell', type: 'number' },
    { name: 'notes', label: 'Notes', type: 'textarea' },
  ];
  
  return (
    <div>
      <h2 className="text-2xl font-semibold text-gray-700 mb-4">Hatchery Log</h2>
      <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 bg-gray-50 p-6 rounded-lg shadow-inner">
        {formFields.map(field => (
          <div key={field.name}>
            <label className="block text-sm font-medium text-gray-700">{field.label}</label>
            {field.type === 'textarea' ? (
              <textarea
                name={field.name}
                value={form[field.name]}
                onChange={handleInputChange}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
              />
            ) : (
              <input
                type={field.type}
                name={field.name}
                value={form[field.name]}
                onChange={handleInputChange}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
              />
            )}
          </div>
        ))}
        <div className="md:col-span-2 lg:col-span-3">
          <button
            type="submit"
            className="w-full inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            {editingId ? 'Update Record' : 'Add Record'}
          </button>
        </div>
      </form>
      {renderTable(hatcheryRecords, headers, handleEdit, handleDelete)}
    </div>
  );
};

// Chick Sales Component
const ChickSales = () => {
  const [chickSales, setChickSales] = useState([]);
  const [form, setForm] = useState({ id: '', hatchDate: '', totalChicks: '', dateOfSale: '', customerName: '', customerAddress: '', numberSold: '', remaining: '', notes: '' });
  const [editingId, setEditingId] = useState(null);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setForm({ ...form, [name]: value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    const remaining = form.totalChicks - form.numberSold;
    const newRecord = { ...form, remaining };
    if (editingId) {
      setChickSales(chickSales.map(sale => sale.id === editingId ? { ...sale, ...newRecord } : sale));
      setEditingId(null);
    } else {
      setChickSales([...chickSales, { ...newRecord, id: uuidv4() }]);
    }
    setForm({ id: '', hatchDate: '', totalChicks: '', dateOfSale: '', customerName: '', customerAddress: '', numberSold: '', remaining: '', notes: '' });
  };

  const handleEdit = (record) => {
    setForm(record);
    setEditingId(record.id);
  };

  const handleDelete = (id) => {
    setChickSales(chickSales.filter(sale => sale.id !== id));
  };
  
  const renderTable = (data, headers, handleEdit, handleDelete) => {
    if (data.length === 0) {
      return <p className="text-gray-500 text-center">No records to display. Add a new one using the form above.</p>;
    }
    return (
      <div className="overflow-x-auto mt-6">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              {headers.map((header) => (
                <th key={header.key} scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  {header.label}
                </th>
              ))}
              <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {data.map((item) => (
              <tr key={item.id}>
                {headers.map((header) => (
                  <td key={header.key} className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {item[header.key]}
                  </td>
                ))}
                <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                  <button onClick={() => handleEdit(item)} className="text-indigo-600 hover:text-indigo-900 mr-4">Edit</button>
                  <button onClick={() => handleDelete(item.id)} className="text-red-600 hover:text-red-900">Delete</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  };
  
  const headers = [
    { key: 'hatchDate', label: 'Hatch Date' },
    { key: 'totalChicks', label: 'Total Chicks Hatched' },
    { key: 'dateOfSale', label: 'Date of Sale' },
    { key: 'customerName', label: 'Customer Name' },
    { key: 'customerAddress', label: 'Customer Address' },
    { key: 'numberSold', label: 'Number Sold' },
    { key: 'remaining', label: 'Remaining Inventory' },
    { key: 'notes', label: 'Notes' },
  ];
  
  const formFields = [
    { name: 'hatchDate', label: 'Hatch Date', type: 'date' },
    { name: 'totalChicks', label: 'Total Chicks Hatched', type: 'number' },
    { name: 'dateOfSale', label: 'Date of Sale', type: 'date' },
    { name: 'customerName', label: 'Customer Name', type: 'text' },
    { name: 'customerAddress', label: 'Customer Address', type: 'textarea' },
    { name: 'numberSold', label: 'Number Sold', type: 'number' },
    { name: 'notes', label: 'Notes', type: 'textarea' },
  ];

  return (
    <div>
      <h2 className="text-2xl font-semibold text-gray-700 mb-4">Chick Sales</h2>
      <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 bg-gray-50 p-6 rounded-lg shadow-inner">
        {formFields.map(field => (
          <div key={field.name}>
            <label className="block text-sm font-medium text-gray-700">{field.label}</label>
            {field.type === 'textarea' ? (
              <textarea
                name={field.name}
                value={form[field.name]}
                onChange={handleInputChange}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
              />
            ) : (
              <input
                type={field.type}
                name={field.name}
                value={form[field.name]}
                onChange={handleInputChange}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
              />
            )}
          </div>
        ))}
        <div className="md:col-span-2 lg:col-span-3">
          <button
            type="submit"
            className="w-full inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            {editingId ? 'Update Record' : 'Add Record'}
          </button>
        </div>
      </form>
    </form>
      {renderTable(chickSales, headers, handleEdit, handleDelete)}
    </div>
  );
};

// Egg Sales Component
const EggSales = () => {
  const [eggSales, setEggSales] = useState([]);
  const [form, setForm] = useState({ id: '', dateOfSale: '', flockId: '', numEggs: '', customerName: '', customerAddress: '', notes: '' });
  const [editingId, setEditingId] = useState(null);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setForm({ ...form, [name]: value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (editingId) {
      setEggSales(eggSales.map(sale => sale.id === editingId ? { ...sale, ...form } : sale));
      setEditingId(null);
    } else {
      setEggSales([...eggSales, { ...form, id: uuidv4() }]);
    }
    setForm({ id: '', dateOfSale: '', flockId: '', numEggs: '', customerName: '', customerAddress: '', notes: '' });
  };

  const handleEdit = (record) => {
    setForm(record);
    setEditingId(record.id);
  };

  const handleDelete = (id) => {
    setEggSales(eggSales.filter(sale => sale.id !== id));
  };
  
  const renderTable = (data, headers, handleEdit, handleDelete) => {
    if (data.length === 0) {
      return <p className="text-gray-500 text-center">No records to display. Add a new one using the form above.</p>;
    }
    return (
      <div className="overflow-x-auto mt-6">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              {headers.map((header) => (
                <th key={header.key} scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  {header.label}
                </th>
              ))}
              <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {data.map((item) => (
              <tr key={item.id}>
                {headers.map((header) => (
                  <td key={header.key} className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {item[header.key]}
                  </td>
                ))}
                <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                  <button onClick={() => handleEdit(item)} className="text-indigo-600 hover:text-indigo-900 mr-4">Edit</button>
                  <button onClick={() => handleDelete(item.id)} className="text-red-600 hover:text-red-900">Delete</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  };
  
  const headers = [
    { key: 'dateOfSale', label: 'Date of Sale' },
    { key: 'flockId', label: 'Flock ID' },
    { key: 'numEggs', label: 'Number of Eggs' },
    { key: 'customerName', label: 'Customer Name' },
    { key: 'customerAddress', label: 'Customer Address' },
    { key: 'notes', label: 'Notes' },
  ];
  
  const formFields = [
    { name: 'dateOfSale', label: 'Date of Sale', type: 'date' },
    { name: 'flockId', label: 'Flock ID', type: 'text' },
    { name: 'numEggs', label: 'Number of Eggs', type: 'number' },
    { name: 'customerName', label: 'Customer Name', type: 'text' },
    { name: 'customerAddress', label: 'Customer Address', type: 'textarea' },
    { name: 'notes', label: 'Notes', type: 'textarea' },
  ];
  
  return (
    <div>
      <h2 className="text-2xl font-semibold text-gray-700 mb-4">Egg Sales</h2>
      <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 bg-gray-50 p-6 rounded-lg shadow-inner">
        {formFields.map(field => (
          <div key={field.name}>
            <label className="block text-sm font-medium text-gray-700">{field.label}</label>
            {field.type === 'textarea' ? (
              <textarea
                name={field.name}
                value={form[field.name]}
                onChange={handleInputChange}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
              />
            ) : (
              <input
                type={field.type}
                name={field.name}
                value={form[field.name]}
                onChange={handleInputChange}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
              />
            )}
          </div>
        ))}
        <div className="md:col-span-2 lg:col-span-3">
          <button
            type="submit"
            className="w-full inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            {editingId ? 'Update Record' : 'Add Record'}
          </button>
        </div>
      </form>
      {renderTable(eggSales, headers, handleEdit, handleDelete)}
    </div>
  );
};

export default App;
