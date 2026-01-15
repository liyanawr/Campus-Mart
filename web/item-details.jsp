<%-- 
    Document   : item-details
    Created on : Nov 18, 2025, 8:55:03 PM
    Author     : Afifah Isnarudin
--%>

<%@page import="com.marketplace.dao.UserDAO"%>
<%@page import="com.marketplace.dao.ItemDAO"%>
<%@page import="com.marketplace.model.Item"%>
<%@page import="com.marketplace.model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String idStr = request.getParameter("id");
    if (idStr == null) { response.sendRedirect("home.jsp"); return; }
    
    Item item = new ItemDAO().getItemById(Integer.parseInt(idStr));
    if (item == null) { response.sendRedirect("home.jsp"); return; }

    // FIX: Calling getUserByUserId instead of getUserByStudentId
    User seller = new UserDAO().getUserByUserId(item.getSellerId());
    User currentUser = (User) session.getAttribute("loggedUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= item.getItemName() %> | CampusMart</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-slate-50 font-sans text-slate-900">
    <nav class="bg-white border-b border-slate-200 sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-6 h-16 flex items-center">
            <a href="home.jsp" class="text-slate-500 hover:text-indigo-600 font-bold transition flex items-center gap-2">
                <i class="fas fa-arrow-left"></i> Back to Marketplace
            </a>
        </div>
    </nav>

    <main class="max-w-5xl mx-auto px-6 py-12">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
            <!-- Product Image -->
            <div class="bg-white rounded-[2.5rem] p-4 shadow-sm border border-slate-200 overflow-hidden">
                <div class="aspect-square bg-slate-100 rounded-[2rem] flex items-center justify-center overflow-hidden">
                    <% if(item.getItemPhoto() != null && !item.getItemPhoto().equals("default.png")) { %>
                        <img src="uploads/<%= item.getItemPhoto() %>" class="w-full h-full object-cover">
                    <% } else { %>
                        <i class="fas fa-image text-slate-300 text-8xl"></i>
                    <% } %>
                </div>
            </div>

            <!-- Product Info -->
            <div class="flex flex-col">
                <span class="text-indigo-600 font-black uppercase tracking-widest text-xs mb-2">Item ID: <%= item.getItemId() %></span>
                <h1 class="text-4xl font-black text-slate-900 mb-4 leading-tight"><%= item.getItemName() %></h1>
                <div class="text-3xl font-black text-indigo-600 mb-8 italic">RM <%= String.format("%.2f", item.getPrice()) %></div>
                
                <div class="bg-white rounded-3xl p-6 border border-slate-200 mb-8">
                    <h3 class="font-black text-slate-800 uppercase text-xs tracking-widest mb-3">Description</h3>
                    <p class="text-slate-600 leading-relaxed"><%= item.getDescription() %></p>
                </div>

                <div class="space-y-4">
                    <% if(currentUser != null) { %>
                        <form action="CartServlet" method="POST">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
                            <button type="submit" class="w-full bg-indigo-600 text-white font-black py-5 rounded-2xl shadow-xl shadow-indigo-100 hover:bg-indigo-700 transition transform active:scale-95 flex items-center justify-center gap-3 text-lg">
                                <i class="fas fa-cart-plus text-indigo-200"></i> Add to Cart
                            </button>
                        </form>
                    <% } else { %>
                        <a href="login.jsp" class="block w-full text-center bg-slate-900 text-white font-black py-5 rounded-2xl shadow-xl hover:bg-indigo-600 transition text-lg">
                            Login to Purchase
                        </a>
                    <% } %>
                </div>

                <!-- Seller Badge -->
                <div class="mt-auto pt-8 border-t border-slate-200 flex items-center gap-4">
                    <div class="w-12 h-12 bg-indigo-50 rounded-2xl flex items-center justify-center text-indigo-600 text-xl font-black shadow-inner">
                        <%= seller != null ? seller.getName().substring(0, 1) : "?" %>
                    </div>
                    <div>
                        <p class="text-slate-400 font-bold text-[10px] uppercase tracking-widest">Seller</p>
                        <p class="font-black text-slate-800"><%= seller != null ? seller.getName() : "Unknown" %></p>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>