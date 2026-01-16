<%@page import="com.marketplace.model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("loggedUser");
    if(user == null || !user.isIsSeller()) { response.sendRedirect("become_seller.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Post New Item | CampusMart</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-indigo-600 p-6 min-h-screen flex items-center justify-center">
    <div class="bg-white w-full max-w-2xl rounded-[2.5rem] p-10 md:p-14 shadow-2xl">
        <h1 class="text-3xl font-black text-slate-900 mb-2">Create Listing</h1>
        <p class="text-slate-400 font-medium mb-10">Fill in details to start selling.</p>

        <%-- Error Alerts --%>
        <% 
            String error = request.getParameter("error");
            if ("InvalidPrice".equals(error)) { %>
                <div class="bg-red-50 text-red-600 p-4 rounded-2xl mb-8 text-center text-sm font-bold border border-red-100">
                    <i class="fas fa-exclamation-circle mr-2"></i> Price must be a valid number
                </div>
        <%  } else if ("UploadError".equals(error)) { %>
                <div class="bg-red-50 text-red-600 p-4 rounded-2xl mb-8 text-center text-sm font-bold border border-red-100">
                    <i class="fas fa-camera mr-2"></i> Failed to upload image. Please try again
                </div>
        <%  } %>

        <form action="SellItemServlet" method="POST" enctype="multipart/form-data" class="space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="md:col-span-2">
                    <label class="block text-[10px] font-black uppercase text-slate-400 mb-2">Item Title</label>
                    <input type="text" name="itemName" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none outline-none focus:ring-2 focus:ring-indigo-600 font-bold">
                </div>
                <div>
                    <label class="block text-[10px] font-black uppercase text-slate-400 mb-2">Price (RM)</label>
                    <input type="number" step="0.01" name="price" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none outline-none focus:ring-2 focus:ring-indigo-600 font-bold">
                </div>
                <div>
                    <label class="block text-[10px] font-black uppercase text-slate-400 mb-2">Stock Quantity</label>
                    <input type="number" name="qty" value="1" min="1" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none outline-none focus:ring-2 focus:ring-indigo-600 font-bold">
                </div>
                <div class="md:col-span-2">
                    <label class="block text-[10px] font-black uppercase text-slate-400 mb-2">Payment Preference</label>
                    <select name="preferredPayment" class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none outline-none focus:ring-2 focus:ring-indigo-600 font-bold">
                        <option value="BOTH">Accept Both (QR & COD)</option>
                        <option value="QR">DuitNow QR Only</option>
                        <option value="COD">Cash on Delivery Only</option>
                    </select>
                </div>
                <div class="md:col-span-2">
                    <label class="block text-[10px] font-black uppercase text-slate-400 mb-2">Category</label>
                    <select name="categoryId" class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none outline-none focus:ring-2 focus:ring-indigo-600 font-bold">
                        <option value="1">Textbooks</option>
                        <option value="2">Electronics</option>
                        <option value="3">Clothing</option>
                        <option value="4">Food</option>
                        <option value="5">Others</option>
                    </select>
                </div>
                <div class="md:col-span-2">
                    <label class="block text-[10px] font-black uppercase text-slate-400 mb-2">Photo</label>
                    <input type="file" name="itemPhoto" class="w-full text-xs text-slate-400 file:mr-4 file:py-2 file:px-4 file:rounded-xl file:border-0 file:bg-indigo-50 file:text-indigo-600">
                </div>
                <div class="md:col-span-2">
                    <label class="block text-[10px] font-black uppercase text-slate-400 mb-2">Description</label>
                    <textarea name="description" rows="3" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none outline-none focus:ring-2 focus:ring-indigo-600 font-bold"></textarea>
                </div>
            </div>
            <div class="flex gap-4">
                <button type="submit" class="flex-1 bg-slate-900 text-white font-black py-5 rounded-3xl shadow-xl hover:bg-indigo-600 transition">Publish Now</button>
                <a href="seller_dashboard.jsp" class="flex-1 bg-slate-100 text-slate-500 font-black py-5 rounded-3xl text-center">Cancel</a>
            </div>
        </form>
    </div>
</body>
</html>
