<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Join CampusMart</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-indigo-600 font-sans min-h-screen flex items-center justify-center p-6">
    <div class="bg-white w-full max-w-xl rounded-[2.5rem] shadow-2xl p-10 md:p-14">
        <div class="text-center mb-10">
            <h1 class="text-4xl font-black text-slate-900 tracking-tight">Create Account</h1>
            <p class="text-slate-500 mt-2 font-medium">Join the student marketplace community</p>
        </div>

        <%-- Error Messages --%>
        <% 
            String error = request.getParameter("error");
            if ("AlreadyExists".equals(error)) { %>
                <div class="bg-red-50 text-red-600 p-4 rounded-2xl mb-6 text-center text-sm font-bold border border-red-100">
                    <i class="fas fa-exclamation-circle mr-2"></i> Student ID already exists
                </div>
        <%  } else if ("PasswordMismatch".equals(error)) { %>
                <div class="bg-red-50 text-red-600 p-4 rounded-2xl mb-6 text-center text-sm font-bold border border-red-100">
                    <i class="fas fa-lock mr-2"></i> Passwords do not match
                </div>
        <%  } %>

        <form action="RegisterServlet" method="POST" class="space-y-6">
            <div class="flex p-1 bg-slate-100 rounded-2xl mb-8">
                <label class="flex-1 text-center py-3 rounded-xl cursor-pointer transition has-[:checked]:bg-white has-[:checked]:shadow-md has-[:checked]:text-indigo-600 font-bold text-slate-500 text-sm">
                    <input type="radio" name="userType" value="student" checked class="hidden" onchange="toggleFields()"> Student
                </label>
                <label class="flex-1 text-center py-3 rounded-xl cursor-pointer transition has-[:checked]:bg-white has-[:checked]:shadow-md has-[:checked]:text-indigo-600 font-bold text-slate-500 text-sm">
                    <input type="radio" name="userType" value="non-student" class="hidden" onchange="toggleFields()"> Non-Student
                </label>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div id="id-container">
                    <label id="id-label" class="block text-xs font-black uppercase tracking-widest text-slate-400 mb-2 ml-1">Student ID</label>
                    <input type="text" name="studentId" id="id-input" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none focus:ring-2 focus:ring-indigo-600 outline-none transition font-medium" placeholder="e.g. 2023000111">
                </div>
                <div>
                    <label class="block text-xs font-black uppercase tracking-widest text-slate-400 mb-2 ml-1">Full Name</label>
                    <input type="text" name="name" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none focus:ring-2 focus:ring-indigo-600 outline-none transition font-medium" placeholder="Full Name">
                </div>
                <div>
                    <label class="block text-xs font-black uppercase tracking-widest text-slate-400 mb-2 ml-1">Phone No</label>
                    <input type="text" name="phone" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none focus:ring-2 focus:ring-indigo-600 outline-none transition font-medium" placeholder="0123456789">
                </div>
                <div>
                    <label class="block text-xs font-black uppercase tracking-widest text-slate-400 mb-2 ml-1">Password</label>
                    <input type="password" name="password" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none focus:ring-2 focus:ring-indigo-600 outline-none transition font-medium" placeholder="••••••••">
                </div>
                <div>
                    <label class="block text-xs font-black uppercase tracking-widest text-slate-400 mb-2 ml-1">Confirm Password</label>
                    <input type="password" name="confirmPassword" required class="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none focus:ring-2 focus:ring-indigo-600 outline-none transition font-medium" placeholder="••••••••">
                </div>
            </div>

            <input type="hidden" name="idType" id="idType" value="STUDENT">
            <button type="submit" class="w-full bg-slate-900 text-white font-black py-5 rounded-2xl shadow-xl hover:bg-indigo-600 transform transition active:scale-95 text-lg mt-4">
                Register Now
            </button>
        </form>

        <p class="mt-10 text-center text-slate-500 font-medium">Already have an account? <a href="login.jsp" class="text-indigo-600 font-black hover:underline">Log in</a></p>
    </div>

    <script>
        function toggleFields() {
            const isStudent = document.querySelector('input[name="userType"]:checked').value === 'student';
            const label = document.getElementById('id-label');
            const input = document.getElementById('id-input');
            const hiddenType = document.getElementById('idType');
            if (isStudent) {
                label.innerText = 'Student ID';
                input.placeholder = 'e.g. 2023000111';
                hiddenType.value = 'STUDENT';
            } else {
                label.innerText = 'NRIC Number';
                input.placeholder = 'e.g. 990101140000';
                hiddenType.value = 'PUBLIC';
            }
        }
    </script>
</body>
</html>
