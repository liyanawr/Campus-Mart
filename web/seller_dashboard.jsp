<%-- 
    Document   : seller_dashboard
    Created on : Dec 30, 2025, 2:53:12 AM
    Author     : Afifah Isnarudin
--%>

<%@page import="java.util.List, com.marketplace.dao.*, com.marketplace.model.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("loggedUser");
    if(user == null || !user.isIsSeller()) { response.sendRedirect("login.jsp"); return; }
    
    List<Item> myItems = new ItemDAO().getItemsBySellerId(user.getUserId());
    List<Order> mySales = new OrderDAO().getSellerSales(user.getUserId());
    
    double revenue = 0;
    int soldCount = 0;
    int activeListings = 0;
    
    for(Item i : myItems) if("Available".equals(i.getStatus())) activeListings++;
    for(Order s : mySales) {
        if("Completed".equals(s.getStatus())) {
            revenue += s.getPrice();
            soldCount++;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Seller Center | CampusMart</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-slate-50 font-sans text-slate-900">
    <nav class="bg-slate-900 h-20 flex items-center px-10 justify-between sticky top-0 z-50 text-white">
        <a href="home.jsp" class="text-indigo-400 font-black text-2xl tracking-tighter">CampusMart</a>
        <div class="flex items-center gap-8">
            <a href="dashboard.jsp" class="font-black text-xs uppercase text-slate-500 hover:text-white transition">Buyer Mode</a>
            <a href="LogoutServlet" class="bg-red-500/10 text-red-500 p-2 rounded-xl transition hover:bg-red-500"><i class="fas fa-sign-out-alt"></i></a>
        </div>
    </nav>

    <div class="max-w-7xl mx-auto px-10 py-12">
        <!-- Dashboard Statistics -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-16">
            <div class="bg-white p-10 rounded-[2.5rem] border border-slate-200 shadow-sm">
                <p class="text-[10px] font-black uppercase text-slate-400 tracking-widest">Active Listings</p>
                <h3 class="text-4xl font-black mt-2 text-slate-900"><%= activeListings %> Items</h3>
            </div>
            <div class="bg-indigo-600 p-10 rounded-[2.5rem] text-white shadow-2xl shadow-indigo-100">
                <p class="text-[10px] font-black uppercase text-indigo-200 tracking-widest">Revenue</p>
                <h3 class="text-4xl font-black italic mt-2">RM <%= String.format("%.2f", revenue) %></h3>
            </div>
            <div class="bg-white p-10 rounded-[2.5rem] border border-slate-200 shadow-sm">
                <p class="text-[10px] font-black uppercase text-slate-400 tracking-widest">Successful Sales</p>
                <h3 class="text-4xl font-black text-emerald-500 mt-2"><%= soldCount %> Items</h3>
            </div>
        </div>
            
        <div class="flex justify-between items-center mb-10 pt-10 border-t">
            <h2 class="text-3xl font-black tracking-tight">Active Inventory</h2>
            <a href="sell-item.jsp" class="bg-slate-900 text-white px-10 py-5 rounded-[2rem] font-black shadow-xl">+ New Product</a>
        </div>

        <div class="bg-white rounded-[3rem] border overflow-hidden shadow-sm">
            <table class="w-full text-left">
                <thead class="bg-slate-50 border-b">
                    <tr><th class="px-10 py-8 text-[10px] font-black uppercase text-slate-400">Product Info</th><th class="px-10 py-8 text-right text-[10px] font-black uppercase text-slate-400">Manage</th></tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    <% for(Item i : myItems) { %>
                    <tr class="hover:bg-slate-50 transition">
                        <td class="px-10 py-10 flex items-center gap-10">
                            <div class="w-20 h-20 bg-slate-100 rounded-3xl overflow-hidden border shadow-inner"><img src="uploads/<%= i.getItemPhoto() %>" class="w-full h-full object-cover"></div>
                            <div><p class="font-black text-2xl text-slate-800 leading-tight mb-2"><%= i.getItemName() %></p><span class="bg-indigo-50 text-indigo-600 text-[10px] font-black uppercase px-3 py-1 rounded-lg">Stock: <%= i.getQty() %> • RM <%= i.getPrice() %></span></div>
                        </td>
                        <td class="px-10 py-10 text-right space-x-3">
                            <a href="edit-item.jsp?id=<%= i.getItemId() %>" class="inline-flex items-center justify-center w-14 h-14 bg-slate-100 text-slate-400 rounded-2xl hover:bg-indigo-600 hover:text-white transition"><i class="fas fa-edit"></i></a>
                            <a href="DeleteServlet?id=<%= i.getItemId() %>" onclick="return confirm('Delete forever?')" class="inline-flex items-center justify-center w-14 h-14 bg-red-50 text-red-500 rounded-2xl hover:bg-red-500 hover:text-white transition"><i class="fas fa-trash-alt"></i></a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <h2 class="text-3xl font-black mb-10 pt-20 tracking-tight">Orders & Feedback</h2>
        <div class="bg-white rounded-[3rem] border overflow-hidden shadow-sm mb-20">
            <table class="w-full text-left">
                <thead class="bg-slate-50 border-b">
                    <tr><th class="px-10 py-8 text-[10px] font-black uppercase text-slate-400">Order Detail</th><th class="px-10 py-8 text-right text-[10px] font-black uppercase text-slate-400">Action/Rating</th></tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    <% for(Order s : mySales) { %>
                    <tr class="hover:bg-slate-50 transition duration-300">
                        <td class="px-10 py-10">
                            <p class="font-black text-slate-800 text-lg leading-tight"><%= s.getItemName() %></p>
                            <p class="text-xs font-bold text-indigo-600 mt-1 uppercase">WhatsApp: <%= s.getBuyerPhone() %></p>
                        </td>
                        <td class="px-10 py-10 text-right">
                            <% if("Pending".equals(s.getStatus())) { %>
                            <div class="flex justify-end gap-3">
                                <form action="OrderServlet" method="POST"><input type="hidden" name="action" value="updateStatus"><input type="hidden" name="orderId" value="<%= s.getOrderId() %>"><input type="hidden" name="status" value="Completed"><button class="bg-indigo-600 text-white px-5 py-2.5 rounded-2xl font-black text-xs shadow-lg shadow-indigo-100 hover:bg-indigo-700 transition">Confirm Sale</button></form>
                                <form action="OrderServlet" method="POST"><input type="hidden" name="action" value="updateStatus"><input type="hidden" name="orderId" value="<%= s.getOrderId() %>"><input type="hidden" name="status" value="Available"><button class="bg-red-50 text-red-500 px-5 py-2.5 rounded-2xl font-black text-xs hover:bg-red-100 transition">Cancel Order</button></form>
                            </div>
                            <% } else if(s.isIsRated()) { %>
                                <div class="inline-block text-left bg-yellow-50 p-4 rounded-2xl border border-yellow-100 max-w-xs">
                                    <span class="text-[10px] font-black text-yellow-600 uppercase">Rated Transaction</span>
                                    <p class="text-slate-700 font-bold text-xs mt-1">Feedback: "<%= s.getPaymentMethod().substring(s.getPaymentMethod().indexOf("(")+1, s.getPaymentMethod().length()-1) %>"</p>
                                </div>
                            <% } else { %>
                                <span class="text-xs font-black text-slate-300 uppercase tracking-widest italic"><%= s.getStatus() %> Transaction</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>