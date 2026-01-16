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
        
        <%-- Display Session Messages (Success) --%>
        <% 
            String successMsg = (String) session.getAttribute("successMsg");
            if (successMsg != null) { 
        %>
            <div class="bg-green-600 text-white p-6 rounded-[2rem] mb-10 text-center font-black shadow-xl animate-bounce">
                <i class="fas fa-check-circle mr-2"></i> <%= successMsg %>
            </div>
        <% 
                session.removeAttribute("successMsg"); 
            } 
        %>

        <%-- Statistics --%>
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

        <%-- Empty State Logic --%>
        <div class="bg-white rounded-[3rem] border overflow-hidden shadow-sm">
            <% if(myItems.isEmpty()) { %>
                <div class="py-20 text-center">
                    <div class="text-slate-200 text-6xl mb-6"><i class="fas fa-box-open"></i></div>
                    <p class="text-slate-400 font-black text-xl italic">You have no active listings. Start selling now!</p>
                </div>
            <% } else { %>
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
                                <a href="DeleteServlet?id=<%= i.getItemId() %>" onclick="return confirm('Are you sure you want to delete this item? This action cannot be undone.')" class="inline-flex items-center justify-center w-14 h-14 bg-red-50 text-red-500 rounded-2xl hover:bg-red-500 hover:text-white transition"><i class="fas fa-trash-alt"></i></a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>
</body>
</html>
