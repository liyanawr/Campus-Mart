<%-- 
    Document   : dashboard
    Created on : Nov 18, 2025, 8:54:38 PM
    Author     : Afifah Isnarudin
--%>

<%@page import="java.util.*, com.marketplace.dao.*, com.marketplace.model.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("loggedUser");
    if(user == null) { response.sendRedirect("login.jsp"); return; }
    
    // Fetch purchase history using the aligned OrderDAO
    List<Order> history = new OrderDAO().getBuyerHistory(user.getUserId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Dashboard | CampusMart</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-slate-50 font-sans text-slate-900">
    <!-- Navbar -->
    <nav class="h-20 bg-white border-b border-slate-200 flex items-center px-8 justify-between sticky top-0 z-50">
        <a href="home.jsp" class="text-indigo-600 font-black text-2xl tracking-tighter">CampusMart</a>
        <div class="flex items-center gap-6">
            <a href="home.jsp" class="font-black text-xs uppercase tracking-widest text-slate-500 hover:text-indigo-600 transition">Marketplace</a>
            <div class="h-8 w-[2px] bg-slate-100"></div>
            <div class="flex items-center gap-4">
                <span class="font-black text-sm text-slate-800"><%= user.getName() %></span>
                <a href="LogoutServlet" class="bg-red-50 text-red-600 w-10 h-10 flex items-center justify-center rounded-xl hover:bg-red-500 hover:text-white transition">
                    <i class="fas fa-sign-out-alt text-sm"></i>
                </a>
            </div>
        </div>
    </nav>

    <div class="max-w-7xl mx-auto px-8 py-16 grid grid-cols-1 lg:grid-cols-12 gap-12">
        <!-- Sidebar -->
        <div class="lg:col-span-4">
            <div class="bg-white rounded-[2.5rem] p-10 shadow-sm border border-slate-200">
                <div class="flex flex-col items-center text-center mb-10">
                    <div class="w-24 h-24 bg-indigo-50 text-indigo-600 rounded-[2rem] flex items-center justify-center text-4xl mb-6 shadow-inner border border-indigo-100">
                        <i class="fas fa-user-graduate"></i>
                    </div>
                    <h2 class="text-3xl font-black tracking-tight text-slate-900"><%= user.getName() %></h2>
                    <p class="text-slate-400 font-black text-[10px] uppercase tracking-[0.3em] mt-2"><%= user.getIdType() %> ID</p>
                </div>
                
                <div class="space-y-5 border-y border-slate-100 py-10">
                    <div class="flex justify-between">
                        <span class="text-slate-400 font-bold text-xs uppercase tracking-widest">Identification</span>
                        <span class="font-black text-slate-700"><%= user.getIdentificationNo() %></span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-slate-400 font-bold text-xs uppercase tracking-widest">Phone</span>
                        <span class="font-black text-slate-700"><%= user.getPhoneNumber() %></span>
                    </div>
                </div>

                <div class="mt-10 space-y-4">
                    <a href="edit-profile.jsp" class="flex items-center justify-center gap-3 w-full py-5 bg-slate-900 text-white rounded-2xl font-black text-sm hover:bg-indigo-600 transition shadow-xl shadow-slate-200 hover:shadow-indigo-100">
                        <i class="fas fa-cog text-xs"></i> Settings
                    </a>
                    <% if(user.isIsSeller()) { %>
                        <a href="seller_dashboard.jsp" class="flex items-center justify-center gap-3 w-full py-5 bg-indigo-600 text-white rounded-2xl font-black text-sm shadow-xl shadow-indigo-100 hover:bg-indigo-700 transition">
                            <i class="fas fa-store text-xs"></i> Seller Center
                        </a>
                    <% } else { %>
                        <a href="become_seller.jsp" class="flex items-center justify-center gap-3 w-full py-5 bg-green-500 text-white rounded-2xl font-black text-sm shadow-xl shadow-green-100 hover:bg-green-600 transition">
                            <i class="fas fa-rocket text-xs"></i> Become a Seller
                        </a>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Purchase History Area -->
        <div class="lg:col-span-8">
            <h2 class="text-4xl font-black mb-10 tracking-tight">Purchase History</h2>
            <div class="bg-white rounded-[2.5rem] shadow-sm border border-slate-200 overflow-hidden">
                <table class="w-full">
                    <thead class="bg-slate-50 border-b border-slate-200">
                        <tr>
                            <th class="px-10 py-6 text-left text-[10px] font-black uppercase tracking-widest text-slate-400">Order Detail</th>
                            <th class="px-10 py-6 text-left text-[10px] font-black uppercase tracking-widest text-slate-400">Amount</th>
                            <th class="px-10 py-6 text-right text-[10px] font-black uppercase tracking-widest text-slate-400">Action</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100">
                        <% if(history.isEmpty()) { %>
                            <tr>
                                <td colspan="3" class="px-10 py-24 text-center text-slate-300 font-black text-xl italic">
                                    No purchases yet. Start shopping!
                                </td>
                            </tr>
                        <% } else { 
                            for(Order o : history) {
                                // Status styling logic
                                String statusBadge = "bg-slate-100 text-slate-600";
                                if("Pending".equals(o.getStatus())) statusBadge = "bg-amber-100 text-amber-600";
                                else if("Completed".equals(o.getStatus())) statusBadge = "bg-emerald-100 text-emerald-600";
                                else if("Sold".equals(o.getStatus())) statusBadge = "bg-rose-100 text-rose-600";

                                // WhatsApp Chat Logic
                                String waMsg = "Hello! I purchased your item '" + o.getItemName() + "' via " + o.getPaymentMethod() + ".";
                                if("QR".equals(o.getPaymentMethod())) waMsg += " I'll upload the payment receipt shortly.";
                                String waUrl = "https://wa.me/" + o.getSellerPhone() + "?text=" + java.net.URLEncoder.encode(waMsg, "UTF-8");
                        %>
                            <tr class="hover:bg-slate-50/50 transition duration-300">
                                <td class="px-10 py-8">
                                    <p class="font-black text-slate-800 text-lg leading-tight"><%= o.getItemName() %></p>
                                    <div class="flex items-center gap-3 mt-2">
                                        <span class="<%= statusBadge %> text-[10px] font-black uppercase tracking-widest px-3 py-1.5 rounded-lg">
                                            <%= o.getStatus() %>
                                        </span>
                                    </div>
                                </td>
                                <td class="px-10 py-8 font-black text-indigo-600 text-xl italic whitespace-nowrap">
                                    RM <%= String.format("%.2f", o.getPrice()) %>
                                </td>
                                <td class="px-10 py-8 text-right">
                                    <div class="flex flex-col items-end gap-2">
                                        <% if("Pending".equals(o.getStatus())) { %>
                                            <a href="<%= waUrl %>" target="_blank" class="flex items-center gap-2 bg-green-500 text-white px-5 py-2.5 rounded-xl font-black text-xs shadow-lg shadow-green-100 hover:bg-green-600 transition">
                                                <i class="fab fa-whatsapp"></i> Chat Seller
                                            </a>
                                        <% } else if("Completed".equals(o.getStatus())) { %>
                                            <% if(!o.isIsRated()) { %>
                                                <a href="rate_seller.jsp?id=<%= o.getOrderId() %>" class="flex items-center gap-2 bg-indigo-600 text-white px-5 py-2.5 rounded-xl font-black text-xs shadow-lg shadow-indigo-100 hover:bg-indigo-700 transition">
                                                    <i class="fas fa-star"></i> Rate Seller
                                                </a>
                                            <% } else { %>
                                                <span class="text-slate-400 font-black text-xs uppercase tracking-widest">
                                                    <i class="fas fa-check-circle"></i> Rated
                                                </span>
                                            <% } %>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>