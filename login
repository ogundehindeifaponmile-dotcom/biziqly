<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BizIQly - Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        /* --- BASE & BACKGROUND --- */
        body {
            background: linear-gradient(180deg, #ffffff 0%, #f0f9ff 40%, #e0f2fe 100%);
            font-family: 'Inter', system-ui, -apple-system, sans-serif;
            overflow-x: hidden;
            min-height: 100vh;
        }

        /* --- ASH DOTS (Extended to Half Page) --- */
        .ash-dots {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            height: 50vh;
            background-image: radial-gradient(circle, #64748b 1.2px, transparent 1.5px);
            background-size: 20px 20px;
            mask-image: linear-gradient(to top, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0.2) 40%, transparent 100%);
            -webkit-mask-image: linear-gradient(to top, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0.2) 40%, transparent 100%);
            pointer-events: none;
            z-index: 0;
        }

        /* --- LIQUID GLASS UI --- */
        .glass-card {
            background: rgba(255, 255, 255, 0.45);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            border: 1px solid rgba(255, 255, 255, 0.8);
            box-shadow: 
                0 8px 32px rgba(14, 165, 233, 0.08),
                inset 0 1px 0 rgba(255, 255, 255, 0.9);
            border-radius: 16px;
        }

        .glass-input {
            background: rgba(255, 255, 255, 0.6);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.9);
            box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.02);
            transition: all 0.3s ease;
        }
        .glass-input:focus {
            background: rgba(255, 255, 255, 0.85);
            border-color: #06b6d4;
            box-shadow: 0 0 0 4px rgba(6, 182, 212, 0.2), inset 0 1px 0 rgba(255,255,255,1);
            outline: none;
        }

        .glass-btn {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.7) 0%, rgba(255, 255, 255, 0.3) 100%);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.9);
            box-shadow: 
                inset 0 1px 0 rgba(255, 255, 255, 1), 
                0 4px 6px -1px rgba(0, 0, 0, 0.05),
                0 2px 4px -1px rgba(0, 0, 0, 0.03);
            border-radius: 8px;
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }
        .glass-btn::before {
            content: '';
            position: absolute;
            top: 0; left: -100%;
            width: 100%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.6), transparent);
            transition: left 0.5s;
        }
        .glass-btn:hover::before { left: 100%; }
        .glass-btn:hover {
            transform: translateY(-1px);
            box-shadow: 
                inset 0 1px 0 rgba(255, 255, 255, 1), 
                0 10px 15px -3px rgba(6, 182, 212, 0.15),
                0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }
        .glass-btn:active { transform: translateY(0); }

        .glass-btn-primary {
            background: linear-gradient(135deg, rgba(6, 182, 212, 0.3) 0%, rgba(14, 165, 233, 0.2) 100%);
            border: 1px solid rgba(6, 182, 212, 0.5);
            color: #0e7490;
        }

        /* --- SLIDESHOW ANIMATION (FIXED FOR CLIPPING) --- */
        .slide-wrapper {
            min-height: 80px; 
            overflow: hidden;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: flex-start;
            padding: 10px 0;
        }

        @media (min-width: 768px) {
            .slide-wrapper {
                min-height: 90px;
            }
        }
        
        .slide-text {
            display: block;
            opacity: 1;
            transform: translateY(0);
            line-height: 1.15;
            transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.6s ease;
        }
        .slide-text.exit { 
            opacity: 0; 
            transform: translateY(-20px); 
        }
        .slide-text.enter { 
            opacity: 0; 
            transform: translateY(20px); 
        }

        /* --- OTP INPUTS --- */
        .otp-input {
            width: 48px; height: 52px;
            text-align: center; font-size: 1.5rem; font-weight: 600;
            background: rgba(255, 255, 255, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.9);
            border-radius: 8px;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.02);
            transition: all 0.2s;
        }
        .otp-input:focus {
            background: rgba(255, 255, 255, 0.9);
            border-color: #06b6d4;
            box-shadow: 0 0 0 4px rgba(6, 182, 212, 0.15);
            outline: none;
        }

        .screen { display: none; }
        .screen.active { display: block; animation: fadeIn 0.4s ease; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        /* --- SPLASH SCREEN --- */
        .splash-screen {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(180deg, #ffffff 0%, #f0f9ff 50%, #e0f2fe 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 100;
            transition: opacity 0.6s ease, visibility 0.6s ease;
        }
        .splash-screen.hidden-splash { opacity: 0; visibility: hidden; }
        
        .logo-icon {
            width: 180px;
            height: auto;
            animation: logoFadeIn 1s ease-out, logoFloat 3s ease-in-out infinite;
        }
        @keyframes logoFadeIn { from { opacity: 0; transform: scale(0.8); } to { opacity: 1; transform: scale(1); } }
        @keyframes logoFloat { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-8px); } }

        .splash-loader {
            width: 40px; height: 3px;
            background: rgba(6, 182, 212, 0.2);
            border-radius: 2px; overflow: hidden; margin-top: 40px;
        }
        .splash-loader::after {
            content: ''; display: block; width: 40%; height: 100%;
            background: linear-gradient(90deg, #06b6d4, #0ea5e9);
            border-radius: 2px; animation: loaderSlide 1.2s ease-in-out infinite;
        }
        @keyframes loaderSlide { 0% { transform: translateX(-100%); } 100% { transform: translateX(350%); } }
    </style>
</head>
<body class="text-slate-800">

    <!-- Ash Dots Background -->
    <div class="ash-dots"></div>

    <!-- SPLASH SCREEN -->
    <div id="splash-screen" class="splash-screen">
        <div class="text-center">
            <img src="https://res.cloudinary.com/dzosy1sic/image/upload/v1793592398/54DB9BAE-E677-4294-B9E1-688540D1F310_rgyrts.png" alt="BizIQly Logo" class="logo-icon">
            <div class="splash-loader"></div>
        </div>
    </div>

    <!-- FLOATING LOGO (Top Center, Absolute) -->
    <div class="fixed top-6 left-0 right-0 z-50 flex justify-center pointer-events-none">
        <img src="https://res.cloudinary.com/dzosy1sic/image/upload/v1793592398/54DB9BAE-E677-4294-B9E1-688540D1F310_rgyrts.png" alt="BizIQly" class="h-10 md:h-12 w-auto opacity-90 drop-shadow-sm">
    </div>

    <!-- MAIN LAYOUT CONTAINER -->
    <div class="relative z-10 min-h-screen flex items-center justify-center p-4 md:p-0 py-24 md:py-0">
        
        <!-- DESKTOP SPLIT WRAPPER -->
        <div class="w-full max-w-6xl grid grid-cols-1 md:grid-cols-2 gap-8 items-center">
            
            <!-- LEFT HALF: BRANDING & GREETING (VISIBLE ON MOBILE) -->
            <div class="flex flex-col justify-center px-4 md:px-12 lg:px-20 order-1 md:order-1 mb-8 md:mb-0">
                <div class="mb-6">
                    <div class="slide-wrapper text-3xl sm:text-4xl lg:text-5xl font-bold tracking-tight text-slate-800">
                        <span id="slideshow-text" class="slide-text">Welcome to BizIQly...</span>
                    </div>
                    <p class="text-slate-500 mt-3 text-base md:text-lg font-medium">Visibility & Fund Management</p>
                </div>
                
                <!-- Feature Highlights (Hidden on very small screens) -->
                <div class="space-y-3 mt-6 hidden sm:block">
                    <div class="flex items-center space-x-3 text-slate-600">
                        <div class="w-2 h-2 rounded-full bg-cyan-500 shrink-0"></div>
                        <span class="text-sm font-medium">Real-time fund tracking</span>
                    </div>
                    <div class="flex items-center space-x-3 text-slate-600">
                        <div class="w-2 h-2 rounded-full bg-cyan-500 shrink-0"></div>
                        <span class="text-sm font-medium">Boost online visibility</span>
                    </div>
                    <div class="flex items-center space-x-3 text-slate-600">
                        <div class="w-2 h-2 rounded-full bg-cyan-500 shrink-0"></div>
                        <span class="text-sm font-medium">Secure OTP authentication</span>
                    </div>
                </div>
            </div>

            <!-- RIGHT HALF: LOGIN CARD -->
            <div class="flex items-center justify-center order-2 md:order-2 w-full max-w-md mx-auto">
                <div class="glass-card p-6 md:p-8 w-full">
                    
                    <!-- SCREEN 1: LOGIN -->
                    <div id="login-screen" class="screen active">
                        <h2 class="text-xl font-semibold text-slate-800 mb-6">Sign in to your account</h2>
                        <form onsubmit="event.preventDefault(); alert('Login API call here');">
                            <div class="mb-4">
                                <label class="block text-xs font-semibold text-slate-600 mb-1.5 uppercase tracking-wide">Email or Phone</label>
                                <input type="text" placeholder="name@company.com" class="glass-input w-full px-4 py-3 rounded-lg text-slate-800 placeholder-slate-400">
                            </div>
                            <div class="mb-6">
                                <label class="block text-xs font-semibold text-slate-600 mb-1.5 uppercase tracking-wide">Password</label>
                                <input type="password" placeholder="••••••••" class="glass-input w-full px-4 py-3 rounded-lg text-slate-800 placeholder-slate-400">
                            </div>
                            <button type="submit" class="glass-btn glass-btn-primary w-full py-3.5 font-semibold">Log In</button>
                        </form>
                        <div class="mt-6 flex justify-between text-sm">
                            <a href="#" onclick="showScreen('forgot-screen')" class="text-cyan-700 hover:text-cyan-900 font-medium">Forgot Password?</a>
                            <a href="#" onclick="showScreen('register-screen')" class="text-cyan-700 hover:text-cyan-900 font-medium">Create Account</a>
                        </div>
                    </div>

                    <!-- SCREEN 2: REGISTER -->
                    <div id="register-screen" class="screen">
                        <h2 class="text-xl font-semibold text-slate-800 mb-6">Get your account</h2>
                        <form onsubmit="event.preventDefault(); sendOTP('register');">
                            <div class="mb-4">
                                <label class="block text-xs font-semibold text-slate-600 mb-1.5 uppercase tracking-wide">Full Name</label>
                                <input type="text" placeholder="John Doe" class="glass-input w-full px-4 py-3 rounded-lg text-slate-800 placeholder-slate-400">
                            </div>
                            <div class="mb-4">
                                <label class="block text-xs font-semibold text-slate-600 mb-1.5 uppercase tracking-wide">Contact Info</label>
                                <input type="text" id="reg-contact" placeholder="Email or Phone Number" class="glass-input w-full px-4 py-3 rounded-lg text-slate-800 placeholder-slate-400">
                            </div>
                            <div class="mb-6">
                                <label class="block text-xs font-semibold text-slate-600 mb-1.5 uppercase tracking-wide">Create Password</label>
                                <input type="password" placeholder="Min 8 characters" class="glass-input w-full px-4 py-3 rounded-lg text-slate-800 placeholder-slate-400">
                            </div>
                            <button type="submit" class="glass-btn glass-btn-primary w-full py-3.5 font-semibold">Send Verification Code</button>
                        </form>
                        <p class="mt-6 text-center text-sm text-slate-600">
                            Already a member? <a href="#" onclick="showScreen('login-screen')" class="text-cyan-700 hover:text-cyan-900 font-medium">Log In</a>
                        </p>
                    </div>

                    <!-- SCREEN 3: FORGOT PASSWORD -->
                    <div id="forgot-screen" class="screen">
                        <h2 class="text-xl font-semibold text-slate-800 mb-2">Reset Password</h2>
                        <p class="text-slate-500 text-sm mb-6">We'll send a verification code to your registered contact.</p>
                        <form onsubmit="event.preventDefault(); sendOTP('forgot');">
                            <div class="mb-6">
                                <label class="block text-xs font-semibold text-slate-600 mb-1.5 uppercase tracking-wide">Email or Phone</label>
                                <input type="text" id="forgot-contact" placeholder="name@gmail.com or +1234567890" class="glass-input w-full px-4 py-3 rounded-lg text-slate-800 placeholder-slate-400">
                            </div>
                            <button type="submit" class="glass-btn glass-btn-primary w-full py-3.5 font-semibold">Send Code</button>
                        </form>
                        <p class="mt-6 text-center text-sm">
                            <a href="#" onclick="showScreen('login-screen')" class="text-cyan-700 hover:text-cyan-900 font-medium">← Back to Login</a>
                        </p>
                    </div>

                    <!-- SCREEN 4: OTP VERIFICATION -->
                    <div id="otp-screen" class="screen">
                        <h2 class="text-xl font-semibold text-slate-800 mb-2">Verify Identity</h2>
                        <p class="text-slate-500 text-sm mb-6">Enter the 6-digit code sent to <span id="otp-destination" class="font-semibold text-slate-700">your device</span>.</p>
                        
                        <div class="flex p-1 rounded-lg mb-6 glass-input">
                            <button id="btn-email" onclick="switchDelivery('email')" class="flex-1 py-2 text-sm font-medium rounded-md transition bg-white/80 shadow-sm text-cyan-800">Gmail</button>
                            <button id="btn-sms" onclick="switchDelivery('sms')" class="flex-1 py-2 text-sm font-medium rounded-md transition text-slate-500">SMS</button>
                        </div>

                        <div class="flex justify-between mb-6" id="otp-container">
                            <input type="text" maxlength="1" class="otp-input" oninput="handleOtpInput(this, 0)" id="otp-0">
                            <input type="text" maxlength="1" class="otp-input" oninput="handleOtpInput(this, 1)" id="otp-1">
                            <input type="text" maxlength="1" class="otp-input" oninput="handleOtpInput(this, 2)" id="otp-2">
                            <input type="text" maxlength="1" class="otp-input" oninput="handleOtpInput(this, 3)" id="otp-3">
                            <input type="text" maxlength="1" class="otp-input" oninput="handleOtpInput(this, 4)" id="otp-4">
                            <input type="text" maxlength="1" class="otp-input" oninput="handleOtpInput(this, 5)" id="otp-5">
                        </div>

                        <button onclick="verifyOTP()" class="glass-btn glass-btn-primary w-full py-3.5 font-semibold">Verify & Continue</button>
                        
                        <p class="mt-6 text-center text-sm text-slate-600">
                            Didn't receive it? <a href="#" onclick="resendOTP()" class="text-cyan-700 hover:text-cyan-900 font-medium">Resend Code</a>
                        </p>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <script>
        // --- SPLASH SCREEN LOGIC ---
        window.addEventListener('load', () => {
            setTimeout(() => {
                document.getElementById('splash-screen').classList.add('hidden-splash');
            }, 2500);
        });

        // --- SLIDESHOW LOGIC ---
        const phrases = [
            "Welcome to BizIQly...",
            "Boost your online visibility...",
            "Manage your funds securely...",
            "Get your account today."
        ];
        let currentPhrase = 0;
        const textElement = document.getElementById('slideshow-text');

        function updateSlideshow() {
            textElement.classList.add('exit');
            setTimeout(() => {
                currentPhrase = (currentPhrase + 1) % phrases.length;
                textElement.textContent = phrases[currentPhrase];
                textElement.classList.remove('exit');
                textElement.classList.add('enter');
                setTimeout(() => textElement.classList.remove('enter'), 50);
            }, 600);
        }
        setInterval(updateSlideshow, 3500);

        // --- UI NAVIGATION ---
        function showScreen(screenId) {
            document.querySelectorAll('.screen').forEach(s => s.classList.remove('active'));
            document.getElementById(screenId).classList.add('active');
        }

        // --- OTP LOGIC ---
        let currentFlow = '';
        let contactValue = '';

        function sendOTP(flow) {
            currentFlow = flow;
            contactValue = document.getElementById(flow === 'register' ? 'reg-contact' : 'forgot-contact').value;
            
            if (!contactValue) {
                alert('Please enter an email or phone number.');
                return;
            }

            const isEmail = contactValue.includes('@');
            document.getElementById('otp-destination').innerText = isEmail ? contactValue : 'your phone';
            switchDelivery(isEmail ? 'email' : 'sms');
            
            console.log(`Sending OTP to ${contactValue}`);
            showScreen('otp-screen');
        }

        function switchDelivery(method) {
            const btnEmail = document.getElementById('btn-email');
            const btnSms = document.getElementById('btn-sms');

            if (method === 'email') {
                btnEmail.className = 'flex-1 py-2 text-sm font-medium rounded-md transition bg-white/80 shadow-sm text-cyan-800';
                btnSms.className = 'flex-1 py-2 text-sm font-medium rounded-md transition text-slate-500';
            } else {
                btnSms.className = 'flex-1 py-2 text-sm font-medium rounded-md transition bg-white/80 shadow-sm text-cyan-800';
                btnEmail.className = 'flex-1 py-2 text-sm font-medium rounded-md transition text-slate-500';
            }
        }

        function handleOtpInput(input, index) {
            if (input.value.length === 1 && index < 5) {
                document.getElementById('otp-' + (index + 1)).focus();
            }
            input.addEventListener('keydown', function(e) {
                if (e.key === 'Backspace' && input.value === '' && index > 0) {
                    document.getElementById('otp-' + (index - 1)).focus();
                }
            });
        }

        function verifyOTP() {
            let otp = '';
            for (let i = 0; i < 6; i++) otp += document.getElementById('otp-' + i).value;
            
            if (otp.length < 6) {
                alert('Please enter the full 6-digit code.');
                return;
            }

            alert('OTP Verified! Redirecting...');
        }

        function resendOTP() {
            alert(`A new code has been sent.`);
            for (let i = 0; i < 6; i++) document.getElementById('otp-' + i).value = '';
            document.getElementById('otp-0').focus();
        }
    </script>
</body>
</html>
