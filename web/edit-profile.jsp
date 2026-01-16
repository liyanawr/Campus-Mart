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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-slate-900 min-h-screen flex items-center justify-center p-6">
    <div class="bg-white w-full max-w-lg rounded-[3rem] p-12 shadow-2xl">
        <h1 class="text-3xl font-black text-slate-900 mb-2">Settings</h1>
        <p class="text-slate-400 font-medium mb-10">Manage your account information.</p>

        <%-- Message Alerts --%>
        <% 
            String successMsg = (String) session.getAttribute("successMsg");
            if (successMsg != null) { %>
                <div class="bg-green-50 text-green-600 p-4 rounded-2xl mb-8 text-center text-sm font-bold border border-green-100">
                    <i class="fas fa-check-circle mr-2"></i> <%= successMsg %>
                </div>
        <% 
                session.removeAttribute("successMsg"); 
            } 
            
            String errorMsg = (String) request.getAttribute("errorMsg");
            if (errorMsg != null) { %>
                <div class="bg-red-50 text-red-600 p-4 rounded-2xl mb-8 text-center text-sm font-bold border border-red-100">
                    <i class="fas fa-exclamation-circle mr-2"></i> <%= errorMsg %>
                </div>
        <% } %>

        <form action="ProfileServlet" method="POST" class="space-y-6">
            <div>
                <label class="block text-[10px] font-black uppercase tracking-widest text-slate-400 mb-2 ml-1">Full Name</label>
                <input type="text" name="name" value="<%= user.getName() %>" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none focus:ring-2 focus:ring-indigo-600 font-bold">
            </div>
            <div>
                <label class="block text-[10px] font-black uppercase tracking-widest text-slate-400 mb-2 ml-1">Phone Number</label>
                <input type="text" name="phone" value="<%= user.getPhoneNumber() %>" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none focus:ring-2 focus:ring-indigo-600 font-bold">
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-[10px] font-black uppercase tracking-widest text-slate-400 mb-2 ml-1">New Password</label>
                    <input type="password" name="password" value="<%= user.getPassword() %>" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none focus:ring-2 focus:ring-indigo-600 font-bold">
                </div>
                <div>
                    <label class="block text-[10px] font-black uppercase tracking-widest text-slate-400 mb-2 ml-1">Confirm Password</label>
                    <input type="password" name="confirmPassword" value="<%= user.getPassword() %>" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none focus:ring-2 focus:ring-indigo-600 font-bold">
                </div>
            </div>
            
            <div class="flex gap-4 pt-6">
                <button type="submit" class="flex-1 bg-indigo-600 text-white font-black py-5 rounded-3xl shadow-xl hover:bg-indigo-700 transition">Save Changes</button>
                <a href="dashboard.jsp" class="flex-1 text-center bg-slate-100 text-slate-500 font-black py-5 rounded-3xl flex items-center justify-center">Back</a>
            </div>
        </form>
    </div>
</body>
</html>
