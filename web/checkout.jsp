<%-- 
    Document   : checkout
    Created on : Dec 30, 2025, 2:00:03 AM
    Author     : Afifah Isnarudin
--%>

<%@page import="com.marketplace.model.*, com.marketplace.dao.*, java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("loggedUser");
    int sellerId = Integer.parseInt(request.getParameter("sellerId"));
    User seller = new UserDAO().getUserByUserId(sellerId);
    String total = request.getParameter("total");
    
    // Modification 7: Fetch preference of the first item to filter options
    CartDAO cartDao = new CartDAO();
    List<CartItem> items = cartDao.getCartItems(user.getUserId());
    String pref = "BOTH";
    for(CartItem ci : items) {
        if(ci.getSellerId() == sellerId) {
            pref = new OrderDAO().getPaymentPreferenceByItemId(ci.getItemId());
            break;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Checkout | CampusMart</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-indigo-600 p-6 min-h-screen flex items-center justify-center">
    <div class="bg-white w-full max-w-lg rounded-[2.5rem] p-10 shadow-2xl relative">
        <!-- Modification 2: Back Link -->
        <a href="cart.jsp" class="absolute top-10 left-10 text-slate-400 hover:text-indigo-600 font-bold text-sm transition">
            <i class="fas fa-arrow-left mr-2"></i> Back to Cart
        </a>

        <h1 class="text-3xl font-black text-center mb-10 mt-6 tracking-tight">Checkout</h1>
        
        <div class="bg-slate-50 p-8 rounded-3xl mb-10 flex justify-between border border-slate-100">
            <span class="font-bold text-slate-400 uppercase text-[10px] tracking-widest">Payable Total</span>
            <span class="font-black text-3xl text-indigo-600 italic">RM <%= total %></span>
        </div>

        <form action="CartServlet" method="POST" class="space-y-10">
            <input type="hidden" name="action" value="checkout">
            <input type="hidden" name="sellerId" value="<%= sellerId %>">
            
            <div class="space-y-4">
                <label class="block text-[10px] font-black uppercase text-slate-400 ml-1">Payment Method</label>
                <div class="grid grid-cols-1 gap-4">
                    <%-- Modification 7: Restriction Logic --%>
                    <% if(!"QR".equals(pref)) { %>
                    <label class="relative flex items-center p-6 rounded-2xl bg-slate-50 cursor-pointer has-[:checked]:bg-indigo-600 has-[:checked]:text-white font-black transition border-2 border-transparent has-[:checked]:border-indigo-300">
                        <input type="radio" name="paymentMethod" value="COD" checked class="hidden" onclick="toggleQR(false)">
                        <i class="fas fa-handshake mr-4 text-xl"></i> Cash on Delivery (COD)
                    </label>
                    <% } %>
                    
                    <% if(!"COD".equals(pref)) { %>
                    <label class="relative flex items-center p-6 rounded-2xl bg-slate-50 cursor-pointer has-[:checked]:bg-indigo-600 has-[:checked]:text-white font-black transition border-2 border-transparent has-[:checked]:border-indigo-300">
                        <input type="radio" name="paymentMethod" value="QR" <%= "QR".equals(pref)?"checked":"" %> class="hidden" onclick="toggleQR(true)">
                        <i class="fas fa-qrcode mr-4 text-xl"></i> DuitNow QR
                    </label>
                    <% } %>
                </div>
            </div>

            <div id="qr-box" class="<%= "QR".equals(pref)?"":"hidden" %> bg-indigo-50 p-8 rounded-[2rem] text-center border-2 border-dashed border-indigo-200">
                <img src="uploads/<%= seller.getPaymentQr() %>" class="w-48 h-48 mx-auto rounded-3xl shadow-xl mb-6" onerror="this.src='https://placehold.co/200?text=No+QR+Image'">
                <p class="text-[10px] font-bold text-indigo-600 italic">Save your receipt for proof of payment!</p>
            </div>

            <button type="submit" class="w-full bg-slate-900 text-white font-black py-5 rounded-3xl shadow-xl hover:bg-indigo-700 transition transform active:scale-95 text-lg">Confirm Purchase</button>
        </form>
    </div>
    <script>function toggleQR(s){ document.getElementById('qr-box').classList.toggle('hidden', !s); }</script>
</body>
</html>