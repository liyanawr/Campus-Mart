<%@page import="com.marketplace.model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("loggedUser");
    if(user == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Become a Seller | CampusMart</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-indigo-600 font-sans p-6 min-h-screen flex items-center justify-center">
    <div class="bg-white w-full max-w-md rounded-[2.5rem] shadow-2xl p-10 md:p-14">
        <div class="text-center mb-10">
            <div class="w-20 h-20 bg-indigo-50 text-indigo-600 rounded-3xl flex items-center justify-center text-3xl mx-auto mb-6 shadow-inner">
                <i class="fas fa-id-card"></i>
            </div>
            <h1 class="text-3xl font-black text-slate-900 tracking-tight">Identity Verification</h1>
            <p class="text-slate-400 font-medium text-sm mt-2">Re-enter your <%= user.getIdType() %> ID to activate your shop.</p>
        </div>

        <%-- Display error messages --%>
        <% 
            String errorMsg = (String) request.getAttribute("errorMsg");
            if (errorMsg != null) { %>
                <div class="bg-red-50 text-red-600 p-4 rounded-2xl mb-8 text-center text-xs font-bold border border-red-100">
                    <i class="fas fa-exclamation-circle mr-2"></i> <%= errorMsg %>
                </div>
        <% } %>

        <form action="ProfileServlet" method="POST" enctype="multipart/form-data" class="space-y-8">
            <input type="hidden" name="action" value="activate_seller">
            
            <div>
                <label class="block text-[10px] font-black uppercase tracking-[0.2em] text-slate-400 mb-2 ml-1">Confirmation ID</label>
                <input type="text" name="verifyId" required 
                       class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none focus:ring-2 focus:ring-indigo-600 outline-none transition font-black text-slate-700"
                       placeholder="Identification No">
            </div>

            <div class="bg-indigo-50/50 p-6 rounded-3xl border border-indigo-100">
                <label class="block text-[10px] font-black uppercase tracking-[0.2em] text-indigo-400 mb-3 ml-1">DuitNow QR (Optional)</label>
                <input type="file" name="qrPhoto" 
                       class="text-xs text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-xl 
                       file:border-0 file:text-[10px] file:font-black file:bg-white file:text-indigo-600 hover:file:bg-indigo-100 transition">
                <p class="text-[10px] text-slate-400 font-bold mt-3 leading-relaxed italic">* If skipped, customers can only pay via Cash (COD).</p>
            </div>

            <button type="submit" class="w-full bg-slate-900 text-white font-black py-5 rounded-3xl shadow-xl hover:bg-indigo-600 transform transition active:scale-95 text-lg">
                Activate Shop
            </button>
        </form>
        
        <p class="mt-8 text-center"><a href="dashboard.jsp" class="text-slate-400 font-bold text-sm hover:text-indigo-600 transition">Back to Dashboard</a></p>
    </div>
</body>
</html>
