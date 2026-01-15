<%-- 
    Document   : edit-item
    Created on : Nov 18, 2025, 8:55:19 PM
    Author     : Afifah Isnarudin
--%>
<%@page import="com.marketplace.dao.ItemDAO, com.marketplace.model.Item"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String idStr = request.getParameter("id");
    Item item = new ItemDAO().getItemById(Integer.parseInt(idStr));
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Listing | CampusMart</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-indigo-600 p-6 min-h-screen flex items-center justify-center">
    <div class="bg-white w-full max-w-2xl rounded-[2.5rem] p-10 md:p-14 shadow-2xl">
        <h1 class="text-3xl font-black text-slate-900 mb-2">Edit Listing</h1>
        <form action="EditItemServlet" method="POST" class="space-y-6">
            <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="md:col-span-2"><label class="block text-[10px] font-black uppercase text-slate-400 mb-1 ml-1">Title</label><input type="text" name="itemName" value="<%= item.getItemName() %>" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none outline-none focus:ring-2 focus:ring-indigo-600 font-bold"></div>
                <div><label class="block text-[10px] font-black uppercase text-slate-400 mb-1 ml-1">Price (RM)</label><input type="number" step="0.01" name="price" value="<%= item.getPrice() %>" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none outline-none focus:ring-2 focus:ring-indigo-600 font-bold"></div>
                <div><label class="block text-[10px] font-black uppercase text-slate-400 mb-1 ml-1">Quantity</label><input type="number" name="qty" value="<%= item.getQty() %>" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none outline-none focus:ring-2 focus:ring-indigo-600 font-bold"></div>
                <div class="md:col-span-2"><label class="block text-[10px] font-black uppercase text-slate-400 mb-1 ml-1">Allowed Payment</label>
                    <select name="preferredPayment" class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none focus:ring-2 focus:ring-indigo-600 font-bold">
                        <option value="BOTH" <%= "BOTH".equals(item.getPreferredPayment())?"selected":"" %>>Both (QR & COD)</option>
                        <option value="QR" <%= "QR".equals(item.getPreferredPayment())?"selected":"" %>>QR Only</option>
                        <option value="COD" <%= "COD".equals(item.getPreferredPayment())?"selected":"" %>>COD Only</option>
                    </select>
                </div>
                <div class="md:col-span-2"><label class="block text-[10px] font-black uppercase text-slate-400 mb-1 ml-1">Current Status</label>
                    <select name="status" class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none focus:ring-2 focus:ring-indigo-600 font-bold">
                        <option value="Available" <%= "Available".equals(item.getStatus())?"selected":"" %>>Available</option>
                        <option value="Sold" <%= "Sold".equals(item.getStatus())?"selected":"" %>>Sold</option>
                    </select>
                </div>
            </div>
            <div class="flex gap-4 pt-6"><button type="submit" class="flex-1 bg-slate-900 text-white font-black py-5 rounded-3xl shadow-xl hover:bg-indigo-600 transition">Update Product</button><a href="seller_dashboard.jsp" class="flex-1 text-center bg-slate-100 text-slate-500 font-black py-5 rounded-3xl flex items-center justify-center">Cancel</a></div>
        </form>
    </div>
</body>
</html>