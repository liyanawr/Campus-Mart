<%-- 
    Document   : edit_profile
    Created on : Dec 30, 2025, 2:58:33 AM
    Author     : Afifah Isnarudin
--%>

<%@page import="com.marketplace.model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("loggedUser");
    if(user == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile | CampusMart</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-50 min-h-screen flex items-center justify-center p-6">
    <div class="bg-white w-full max-w-xl rounded-[2.5rem] shadow-2xl p-10 md:p-14">
        <h1 class="text-4xl font-black text-slate-900 mb-2 tracking-tight">Profile Settings</h1>
        <p class="text-slate-400 font-medium mb-12">Update your information and security.</p>
        
        <% if("WrongOldPassword".equals(request.getParameter("error"))) { %>
            <div class="bg-red-50 text-red-600 p-4 rounded-2xl mb-8 text-center text-[10px] font-black border border-red-100 uppercase tracking-widest">
                Verification Failed: Incorrect Current Password!
            </div>
        <% } %>

        <form action="ProfileServlet" method="POST" enctype="multipart/form-data" class="space-y-8">
            <input type="hidden" name="action" value="edit_profile">
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="md:col-span-2">
                    <label class="block text-[10px] font-black uppercase text-slate-400 mb-3 ml-1 tracking-widest">Full Name</label>
                    <input type="text" name="name" value="<%= user.getName() %>" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none outline-none focus:ring-2 focus:ring-indigo-600 font-bold text-slate-700 transition">
                </div>
                
                <div class="md:col-span-2">
                    <label class="block text-[10px] font-black uppercase text-slate-400 mb-3 ml-1 tracking-widest">Phone Number</label>
                    <input type="text" name="phone" value="<%= user.getPhoneNumber() %>" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none outline-none focus:ring-2 focus:ring-indigo-600 font-bold text-slate-700 transition">
                </div>

                <div>
                    <label class="block text-[10px] font-black uppercase text-slate-400 mb-3 ml-1 tracking-widest">New Password (Optional)</label>
                    <input type="password" name="password" placeholder="••••••••" class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none outline-none focus:ring-2 focus:ring-indigo-600 font-bold text-slate-700 transition">
                </div>

                <div>
                    <label class="block text-[10px] font-black uppercase text-indigo-600 mb-3 ml-1 tracking-widest italic font-black">Current Password *</label>
                    <input type="password" name="oldPassword" required placeholder="Verify identity" class="w-full px-6 py-4 rounded-2xl bg-indigo-50 border-none outline-none focus:ring-2 focus:ring-indigo-600 font-black text-slate-700 shadow-inner">
                </div>
            </div>

            <div class="flex gap-4 pt-6">
                <button type="submit" class="flex-1 bg-indigo-600 text-white font-black py-5 rounded-3xl shadow-xl shadow-indigo-100 hover:bg-indigo-700 transition transform active:scale-95 text-lg">Update Profile</button>
                <a href="dashboard.jsp" class="flex-1 text-center bg-slate-100 text-slate-500 font-black py-5 rounded-3xl hover:bg-slate-200 transition text-lg flex items-center justify-center">Cancel</a>
            </div>
        </form>
    </div>
</body>
</html>