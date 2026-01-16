<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | CampusMart</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-slate-50 font-sans h-screen flex items-center justify-center px-4 overflow-hidden relative">
    <div class="absolute top-0 left-0 w-64 h-64 bg-indigo-100 rounded-full mix-blend-multiply filter blur-3xl opacity-70 -translate-x-1/2 -translate-y-1/2"></div>
    <div class="absolute bottom-0 right-0 w-96 h-96 bg-blue-100 rounded-full mix-blend-multiply filter blur-3xl opacity-70 translate-x-1/3 translate-y-1/3"></div>

    <div class="bg-white/80 backdrop-blur-xl w-full max-w-md rounded-[2.5rem] shadow-2xl shadow-indigo-100 p-10 md:p-14 border border-white relative z-10">
        <div class="text-center mb-12">
            <div class="inline-flex items-center justify-center w-20 h-20 bg-indigo-600 text-white rounded-3xl shadow-xl shadow-indigo-200 text-3xl mb-6">
                <i class="fas fa-graduation-cap"></i>
            </div>
            <h1 class="text-3xl font-black text-slate-900 tracking-tight">Welcome Back</h1>
            <p class="text-slate-500 mt-3 font-medium">Log in to your campus account</p>
        </div>

        <%-- Alerts Module --%>
        <% 
            String status = request.getParameter("status");
            if ("fail".equals(status)) { %>
                <div class="bg-red-50 text-red-600 p-4 rounded-2xl mb-8 text-center text-sm font-bold border border-red-100 animate-pulse">
                    <i class="fas fa-exclamation-circle mr-2"></i> Invalid Student ID or Password
                </div>
        <%  } else if ("Registered".equals(status)) { %>
                <div class="bg-green-50 text-green-600 p-4 rounded-2xl mb-8 text-center text-sm font-bold border border-green-100">
                    <i class="fas fa-check-circle mr-2"></i> Account created! You can now login with your Student ID
                </div>
        <%  } else if ("LoggedOut".equals(status)) { %>
                <div class="bg-indigo-50 text-indigo-600 p-4 rounded-2xl mb-8 text-center text-sm font-bold border border-indigo-100">
                    <i class="fas fa-info-circle mr-2"></i> You have been successfully logged out
                </div>
        <%  } else if ("AccessDenied".equals(status)) { %>
                <div class="bg-amber-50 text-amber-600 p-4 rounded-2xl mb-8 text-center text-sm font-bold border border-amber-100">
                    <i class="fas fa-shield-alt mr-2"></i> Please login first to access the dashboard
                </div>
        <%  } %>

        <form action="LoginServlet" method="POST" class="space-y-6">
            <div>
                <label class="block text-xs font-black uppercase tracking-widest text-slate-400 mb-2 ml-1">ID or NRIC</label>
                <div class="relative">
                    <span class="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400"><i class="fas fa-user"></i></span>
                    <input type="text" name="studentId" required class="w-full pl-12 pr-6 py-4 rounded-2xl bg-slate-50 border-none focus:ring-2 focus:ring-indigo-600 outline-none transition font-medium" placeholder="Enter Identification No">
                </div>
            </div>
            <div>
                <label class="block text-xs font-black uppercase tracking-widest text-slate-400 mb-2 ml-1">Password</label>
                <div class="relative">
                    <span class="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400"><i class="fas fa-lock"></i></span>
                    <input type="password" name="password" required class="w-full pl-12 pr-6 py-4 rounded-2xl bg-slate-50 border-none focus:ring-2 focus:ring-indigo-600 outline-none transition font-medium" placeholder="••••••••">
                </div>
            </div>
            <button type="submit" class="w-full bg-indigo-600 text-white font-black py-5 rounded-2xl shadow-xl shadow-indigo-200 hover:bg-indigo-700 hover:shadow-indigo-300 transform transition active:scale-95 text-lg">
                Login
            </button>
        </form>

        <div class="mt-12 text-center">
            <p class="text-slate-500 font-medium">New member? <a href="register.jsp" class="text-indigo-600 font-black hover:underline">Join Now</a></p>
            <div class="mt-6 pt-6 border-t border-slate-100">
                <a href="home.jsp" class="text-sm font-bold text-slate-400 hover:text-indigo-600 transition">
                    <i class="fas fa-arrow-left mr-2"></i> Browse as Guest
                </a>
            </div>
        </div>
    </div>
</body>
</html>
