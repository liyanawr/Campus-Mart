<%-- 
    Document   : cart
    Created on : Dec 30, 2025, 1:59:16 AM
    Author     : Afifah Isnarudin
--%>

<%@page import="java.util.*"%>
<%@page import="com.marketplace.dao.CartDAO, com.marketplace.model.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("loggedUser");
    if(user == null) { response.sendRedirect("login.jsp"); return; }
    
    List<CartItem> cartItems = new CartDAO().getCartItems(user.getUserId());
    
    // COMPATIBILITY FIX: Replaced Streams with standard HashMap loop for Java 1.5/7 compatibility
    Map<Integer, List<CartItem>> sellerGroups = new HashMap<Integer, List<CartItem>>();
    for (CartItem item : cartItems) {
        Integer sId = item.getSellerId();
        if (!sellerGroups.containsKey(sId)) {
            sellerGroups.put(sId, new ArrayList<CartItem>());
        }
        sellerGroups.get(sId).add(item);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Cart | CampusMart</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-slate-50 font-sans text-slate-900">
    <nav class="bg-white border-b border-slate-200">
        <div class="max-w-5xl mx-auto px-6 h-20 flex justify-between items-center">
            <a href="home.jsp" class="text-indigo-600 font-black text-2xl tracking-tighter">CampusMart</a>
            <a href="dashboard.jsp" class="font-bold text-slate-500 hover:text-indigo-600 uppercase text-xs tracking-widest transition">Dashboard</a>
        </div>
    </nav>

    <main class="max-w-4xl mx-auto px-6 py-12">
        <h1 class="text-4xl font-black mb-2 tracking-tight text-slate-900">Shopping Cart</h1>
        <p class="text-slate-400 font-medium mb-12">Items are grouped by seller. Pay one seller at a time.</p>

        <% if(cartItems.isEmpty()) { %>
            <div class="text-center py-24 bg-white rounded-[3rem] border border-slate-200 shadow-sm">
                <div class="w-24 h-24 bg-slate-50 text-slate-200 rounded-full flex items-center justify-center mx-auto mb-8 text-4xl shadow-inner">
                    <i class="fas fa-shopping-basket"></i>
                </div>
                <p class="text-slate-400 font-black text-2xl">Your cart is empty</p>
                <a href="home.jsp" class="inline-block mt-8 bg-indigo-600 text-white px-8 py-4 rounded-2xl font-black hover:bg-indigo-700 transition shadow-lg shadow-indigo-100">Browse Items</a>
            </div>
        <% } else { 
            for(Map.Entry<Integer, List<CartItem>> entry : sellerGroups.entrySet()) {
                List<CartItem> items = entry.getValue();
                String sellerName = items.get(0).getSellerName();
                double subtotal = 0;
                for(CartItem subItem : items) { subtotal += subItem.getPrice(); }
        %>
            <div class="bg-white rounded-[2.5rem] shadow-sm border border-slate-200 overflow-hidden mb-10">
                <div class="bg-slate-50/80 px-10 py-5 border-b border-slate-200 flex justify-between items-center">
                    <span class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Seller Account</span>
                    <span class="font-black text-slate-800 text-lg"><%= sellerName %></span>
                </div>
                
                <div class="p-10 space-y-8">
                    <% for(CartItem ci : items) { %>
                        <div class="flex items-center gap-8">
                            <div class="w-20 h-20 bg-slate-100 rounded-2xl flex-shrink-0 overflow-hidden shadow-inner border border-slate-200">
                                <img src="uploads/<%= ci.getItemPhoto() %>" class="w-full h-full object-cover">
                            </div>
                            <div class="flex-grow">
                                <h4 class="font-black text-xl text-slate-800 leading-tight mb-1"><%= ci.getItemName() %></h4>
                                <p class="text-indigo-600 font-black text-lg italic">RM <%= String.format("%.2f", ci.getPrice()) %></p>
                            </div>
                            <form action="CartServlet" method="POST" onsubmit="return confirm('Remove item?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="cartId" value="<%= ci.getCartId() %>">
                                <button type="submit" class="w-16 h-16 rounded-[1.5rem] bg-red-50 text-red-300 hover:text-red-500 hover:bg-red-100 transition-all flex items-center justify-center transform hover:rotate-12">
                                    <i class="fas fa-trash-alt text-lg"></i>
                                </button>
                            </form>
                        </div>
                    <% } %>
                </div>

                <div class="bg-indigo-50/30 p-10 flex flex-col md:flex-row justify-between items-center gap-8 border-t border-indigo-100">
                    <div>
                        <p class="text-slate-400 text-[10px] font-black uppercase tracking-[0.2em] mb-2">Group Subtotal</p>
                        <p class="text-3xl font-black text-indigo-600 italic tracking-tight">RM <%= String.format("%.2f", subtotal) %></p>
                    </div>
                    <form action="checkout.jsp" method="POST" class="w-full md:w-auto">
                        <input type="hidden" name="sellerId" value="<%= entry.getKey() %>">
                        <input type="hidden" name="sellerName" value="<%= sellerName %>">
                        <input type="hidden" name="total" value="<%= String.format("%.2f", subtotal) %>">
                        <button type="submit" class="w-full md:w-auto bg-slate-900 text-white font-black px-12 py-5 rounded-2xl shadow-xl shadow-slate-200 hover:bg-indigo-600 hover:shadow-indigo-100 transition transform active:scale-95 text-lg">
                            Checkout with Seller
                        </button>
                    </form>
                </div>
            </div>
        <% } } %>
    </main>
</body>
</html>