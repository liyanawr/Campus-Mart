<%-- 
    Document   : home
    Created on : Nov 18, 2025, 8:54:25 PM
    Author     : Afifah Isnarudin
--%>

<%@page import="java.util.*, com.marketplace.dao.*, com.marketplace.model.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User currentUser = (User) session.getAttribute("loggedUser");
    String q = request.getParameter("q");
    String cat = request.getParameter("category");
    String sort = request.getParameter("sort");
    List<Item> items = new ItemDAO().searchItems(q, cat, sort);
%>
<!DOCTYPE html>
<html>
<head>
    <title>CampusMart | Discover</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-slate-50 font-sans text-slate-900">
    <nav class="bg-white border-b sticky top-0 z-50 h-20 flex items-center px-8 justify-between">
        <a href="home.jsp" class="text-indigo-600 font-black text-3xl tracking-tighter">CampusMart</a>
        
        <form action="home.jsp" method="GET" class="flex-grow max-w-xl mx-10 relative">
            <input type="text" name="q" value="<%= q!=null?q:"" %>" placeholder="Search textbooks, gadgets..." 
                   class="w-full pl-12 pr-4 py-3 bg-slate-100 rounded-2xl border-none outline-none focus:ring-2 focus:ring-indigo-600 transition font-medium">
            <i class="fas fa-search absolute left-4 top-1/2 -translate-y-1/2 text-slate-400"></i>
        </form>

        <div class="flex items-center gap-6">
            <% if (currentUser == null) { %><a href="login.jsp" class="font-bold">Login</a><% } 
            else { %><a href="cart.jsp" class="text-slate-600 hover:text-indigo-600 transition"><i class="fas fa-shopping-cart text-xl"></i></a>
            <a href="dashboard.jsp" class="bg-indigo-600 text-white px-6 py-3 rounded-2xl font-black shadow-xl">Dashboard</a><% } %>
        </div>
    </nav>

    <main class="max-w-7xl mx-auto px-8 py-12">
        <div class="flex flex-wrap items-center justify-between mb-12 gap-6">
            <h2 class="text-3xl font-black text-slate-800">Marketplace</h2>
            <form action="home.jsp" method="GET" class="flex items-center gap-4">
                <select name="category" onchange="this.form.submit()" class="bg-white border border-slate-200 px-4 py-2 rounded-xl font-bold text-sm outline-none">
                    <option value="0">All Categories</option>
                    <option value="1" <%= "1".equals(cat) ? "selected" : "" %>>Textbooks</option>
                    <option value="2" <%= "2".equals(cat) ? "selected" : "" %>>Electronics</option>
                    <option value="3" <%= "3".equals(cat) ? "selected" : "" %>>Clothing</option>
                    <option value="4" <%= "4".equals(cat) ? "selected" : "" %>>Food</option>
                </select>
                <select name="sort" onchange="this.form.submit()" class="bg-white border border-slate-200 px-4 py-2 rounded-xl font-bold text-sm outline-none">
                    <option value="latest" <%= "latest".equals(sort) ? "selected" : "" %>>Latest</option>
                    <option value="cheap" <%= "cheap".equals(sort) ? "selected" : "" %>>Cheapest</option>
                    <option value="pricey" <%= "pricey".equals(sort) ? "selected" : "" %>>Pricier</option>
                </select>
            </form>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-10">
            <% for (Item i : items) { %>
                <div class="group bg-white rounded-[2rem] border border-slate-100 shadow-sm overflow-hidden hover:shadow-2xl transition duration-500">
                    <div class="h-60 bg-slate-100 relative">
                        <img src="web/uploads/<%= i.getItemPhoto() %>" class="w-full h-full object-cover group-hover:scale-105 transition duration-700">
                        <div class="absolute top-4 left-4 bg-white/90 backdrop-blur px-3 py-1 rounded-xl text-[10px] font-black uppercase tracking-widest text-indigo-600 shadow-sm"><%= i.getCategoryName() %></div>
                    </div>
                    <div class="p-8">
                        <h3 class="font-black text-xl mb-1 truncate text-slate-800"><%= i.getItemName() %></h3>
                        <p class="text-indigo-600 font-black text-2xl mb-8 italic text-right">RM <%= String.format("%.2f", i.getPrice()) %></p>
                        <a href="item-details.jsp?id=<%= i.getItemId() %>" class="block text-center w-full py-4 bg-slate-900 text-white font-black rounded-2xl hover:bg-indigo-600 transition shadow-lg shadow-slate-100">View Details</a>
                    </div>
                </div>
            <% } %>
        </div>
    </main>
</body>
</html>