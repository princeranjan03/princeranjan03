Expt3

% Load ECG signal
data = load('100m.mat');
fs = 1000; % Sampling frequency (adjust if needed)
 
% Check field names in the loaded data structure
fieldnames(data)
 
% Extract ECG signal (replace 'val' with the correct field name if different)
ecg_signal = data.val;
 
% Ensure the signal is a row vector for processing
% ecg_signal = ecg_signal(:);
 
% Design and apply a high-pass filter
hp_cutoff = 0.5; % High-pass cutoff frequency in Hz
hp_order = 4; % Filter order
[b_hp, a_hp] = butter(hp_order, hp_cutoff / (fs / 2), 'high');
ecg_highpass = filtfilt(b_hp, a_hp, ecg_signal);
 
% Design and apply a low-pass filter
lp_cutoff = 40; % Low-pass cutoff frequency in Hz
lp_order = 4; % Filter order
[b_lp, a_lp] = butter(lp_order, lp_cutoff / (fs / 2), 'low');
ecg_lowpass = filtfilt(b_lp, a_lp, ecg_highpass);
 
% Time vector for plotting
time = (0:length(ecg_signal) - 1) / fs;
 
% Plot original and processed ECG signals
figure;
 
% Original ECG signal
subplot(3, 1, 1);
plot(time, ecg_signal);
title('Original ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');
 
% High-pass filtered ECG signal
subplot(3, 1, 2);
plot(time, ecg_highpass);
title('ECG Signal After High-Pass Filtering');
xlabel('Time (s)');
ylabel('Amplitude');
 
% Low-pass filtered ECG signal
subplot(3, 1, 3);
plot(time, ecg_lowpass);
title('ECG Signal After Low-Pass Filtering');
xlabel('Time (s)');
ylabel('Amplitude');


EXpt4
clear;
 
%load ecg signal
fid = fopen('rec_1.dat','r');
data = fread(fid, 'int16');
fclose(fid);
ecg_signal = data(1:2:end);
 
% define parameters
fs = 500;
t = (0: length(ecg_signal)-1)/fs;
 
%high pass filtering
h_cutoff = 0.5;
[b_h, a_h] = butter(2, h_cutoff/(fs/2), 'high');
h_filtered = filtfilt(b_h, a_h, ecg_signal);
 
%low pass filtering
l_cutoff = 50;
[b_l, a_l] = butter(2, l_cutoff/(fs/2), 'low');
l_filtered = filtfilt(b_l, a_l, h_filtered);
 
%detect peaks
[peaks, locs] = findpeaks(l_filtered, 'MinPeakHeight', 0.5, 'MinPeakDistance', fs/2);
 
 
%plot each fckin thing
figure;
subplot(4,1,1);
plot(t, ecg_signal);
title("Original signal");
subplot(4,1,2);
plot(t, h_filtered);
title("High pass filtered signal");
subplot(4,1,3);
plot(t, l_filtered);
title("Low pass filtered signal");
subplot(4,1,4);
plot(t, l_filtered);
hold on;
plot(t(locs), peaks, 'ro');
title("Ecg signal with peaks");
 
% calculate heart rate
rr_interval = diff(locs)/fs;
heart_rate = 60 / mean(rr_interval);
disp("Heart rate is: ");
disp(heart_rate);


EXpt6
clear;
% read the ecg signal
fid = fopen('rec_1.dat', 'r');
data = fread(fid, 'int16');
fclose(fid);
ecg_signal = data(1:2:end);
 
%define parameters
fs = 250;
t = (0: length(ecg_signal) - 1)/fs;
N = length(ecg_signal);
ecg_fft = fft(ecg_signal);
 
figure;
subplot(2,1,1);
plot(t,ecg_signal);
title("Original Signal");
subplot(2,1,2);
plot((1:floor(N/2)), abs(ecg_fft(1:floor(N/2))));
title("FFT of Signal");


expt7
clear;
 
%read ecg
% fid = fopen('rec_1.dat','r');
% data = fread(fid, 'int16');
% fclose(fid);
% ecg_signal = data(1:2:end);
data = load('100m.mat');
ecg_signal = data.val;
 
%define parameters and awgn
fs = 500;
t = (0:length(ecg_signal)-1)/fs;
noise_var = 0.5;  % You can adjust this value
noisy_signal = awgn(ecg_signal, 10*log10(1/noise_var), 'measured');
 
 
%cutoff frequencies
l_cutoff = 30;
h_cutoff = 0.5;
b_cutoff = [30, 249];
 
%low pass
[b_l, a_l] = butter(2, l_cutoff/(fs/2), 'low');
l_filtered = filtfilt(b_l, a_l, noisy_signal);
 
%high pass
[b_h, a_h] = butter(2, h_cutoff/(fs/2), 'high');
h_filtered = filtfilt(b_h, a_h, noisy_signal);
 
%notch filter (band stop)
[b_n, a_n] = butter(2, b_cutoff/(fs/2), 'stop');
n_filtered = filtfilt(b_n, a_n, noisy_signal);
 
%plot all figures
figure;
subplot(5,1,1);
plot(t, ecg_signal);
title('Original Signal'); xlabel('Time (s)'); ylabel('Amplitude');
subplot(5,1,2);
plot(t, noisy_signal);
title('Noisy Signal'); xlabel('Time (s)'); ylabel('Amplitude');
subplot(5,1,3);
plot(t, l_filtered);
title('Low Pass filtered Signal'); xlabel('Time (s)'); ylabel('Amplitude');
subplot(5,1,4);
plot(t, h_filtered);
title('High Pass filtered Signal'); xlabel('Time (s)'); ylabel('Amplitude');
subplot(5,1,5);
plot(t, n_filtered);
title('Notch Filtered Signal'); xlabel('Time (s)'); ylabel('Amplitude');


exp5
% Load the EEG data
data = load('subject00_1_edfm.mat');
 
% Extract fieldnames and EEG signal
fields = fieldnames(data);
disp(fields); % Display the field names to confirm structure
eeg_sig = data.eeg_signal; % Assuming the signal is stored under the 'val' field
num_ch = size(eeg_sig, 1); % Number of channels
 
% Determine the grid size for subplots
rows = ceil(num_ch / 2); % Dynamically set rows to fit all channels
col = 2; % Fixed number of columns
 
% Plot each EEG channel
figure; % Create a new figure
for channel = 1:num_ch
   subplot(rows, col, channel); % Dynamically adjust subplot indices
   plot(eeg_sig(channel, :), 'LineWidth', 1); % Plot the EEG signal for each channel
   title(['EEG Channel ', num2str(channel)], 'FontSize', 10);
   grid on;
   xlabel('Sample Points');
   ylabel('Amplitude');
end
 
 












[![ProfileViews](https://komarev.com/ghpvc/?username=princeranjan03&color=red&style=flat)](https://komarev.com/ghpvc/?username=princeranjan03)
<!-- Intro  -->
<h3 align="center">
        <samp>&gt; Hi 👋, I'm
                <b><a target="_blank" href="https://">Prince Ranjan</a></b>
        </samp>
</h3>


<p align="center">
        <samp>「 I am a full stack web application developer from India 」
        </samp>
</p>


<p align="center">
 <a href="https://" target="blank">
  <img src="https://img.shields.io/badge/Website-DC143C?style=for-the-badge&logo=medium&logoColor=white"/>
 </a>
 <a href="https://www.linkedin.com/in/princeranjan03/" target="_blank">
  <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white"/>
 </a>
        <!-- <a href="https://dev.to/princeranjan03" target="_blank">
  <img src="https://img.shields.io/badge/dev.to-0A0A0A?style=for-the-badge&logo=dev.to&logoColor=white" alt="chirag" />
 </a> -->
 <a href="https://twitter.com/" target="_blank">
  <img src="https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white"/>
 </a>
 <a href="https://www.instagram.com/princeranjan03/" target="_blank">
  <img src="https://img.shields.io/badge/Instagram-fe4164?style=for-the-badge&logo=instagram&logoColor=white"/>
 </a> 
<!--  <a href="" target="_blank">
  <img src="https://img.shields.io/badge/Facebook-20BEFF?&style=for-the-badge&logo=facebook&logoColor=white"/>
  </a> 
</p> -->
<br />

<!-- About Section -->
 # About me
 
<p>

 Hi there! I'm Prince Ranjan, currently pursuing Electronics and Communication Engineering at NIT Jalandhar. I have a passion for coding and specialize in front-end development. I love creating engaging user experiences and exploring new technologies. Nice to meet you! <br/><br/>
 📧 &emsp; Reach me anytime: princeranjan13073@gmail.com<br/><br/>
 💬 &emsp; Ask me about anything [here](https://github.com/princeranjan03/princeranjan03/issues)

</p>
<br/>

<p align="left">
  <a href="https://github.com/princeranjan03?tab=repositories" target="_blank"><img alt="All Repositories" title="All Repositories" src="https://img.shields.io/badge/-All%20Repos-2962FF?style=for-the-badge&logo=koding&logoColor=white"/></a>
</p>

## Use To Code

![Javascript](https://img.shields.io/badge/Javascript-F0DB4F?style=for-the-badge&labelColor=black&logo=javascript&logoColor=F0DB4F)
![React](https://img.shields.io/badge/-React-61DBFB?style=for-the-badge&labelColor=black&logo=react&logoColor=61DBFB)
![Nodejs](https://img.shields.io/badge/Nodejs-3C873A?style=for-the-badge&labelColor=black&logo=node.js&logoColor=3C873A)
![HTML](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)
![Tailwind](https://img.shields.io/badge/Tailwind_CSS-092749?style=for-the-badge&logo=tailwindcss&logoColor=06B6D4&labelColor=000000)
![Redux](https://img.shields.io/badge/Redux-593D88?style=for-the-badge&logo=redux&logoColor=white)
![VSCode](https://img.shields.io/badge/Visual_Studio-0078d7?style=for-the-badge&logo=visual%20studio&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)

<!-- ![Typescript](https://img.shields.io/badge/Typescript-007acc?style=for-the-badge&labelColor=black&logo=typescript&logoColor=007acc) -->
<!-- ![React Native](https://img.shields.io/badge/React_Native-20232A?style=for-the-badge&logo=react&logoColor=61DAFB) -->
<!-- ![Next.js](https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white) -->
<!-- ![Express.js](https://img.shields.io/badge/Express.js-000000?style=for-the-badge&logo=express&logoColor=white) -->
<!-- ![MongoDB](https://img.shields.io/badge/MongoDB-4EA94B?style=for-the-badge&logo=mongodb&logoColor=white) -->
<!-- ![SASS Badge](https://img.shields.io/badge/Sass-CC6699?style=for-the-badge&logo=sass&logoColor=white) -->
<!-- ![Ant-Design](https://img.shields.io/badge/AntDesign-0170FE?style=for-the-badge&logo=antdesign&logoColor=white) -->
<!-- ![Strapi](https://img.shields.io/badge/strapi-2E7EEA?style=for-the-badge&logo=strapi&logoColor=white) -->
<br/>

<!-- ## Top Open Source  -->

<!--[![Portfolio-Website](https://github-readme-stats.vercel.app/api/pin/?username=princeranjan03&repo=Portfolio-Website&border_color=7F3FBF&bg_color=0D1117&title_color=C9D1D9&text_color=8B949E&icon_color=7F3FBF)](https://github.com/princeranjan03/Portfolio-Website)-->
<!--[![Chirag Jain Readme](https://github-readme-stats.vercel.app/api/pin/?username=princeranjan03&repo=princeranjan03&border_color=7F3FBF&bg_color=0D1117&title_color=C9D1D9&text_color=8B949E&icon_color=7F3FBF)](https://github.com/princeranjan03/princeranjan03)-->
<!--[![Weather-WebApp](https://github-readme-stats.vercel.app/api/pin/?username=princeranjan03&repo=Weather-WebApp&border_color=7F3FBF&bg_color=0D1117&title_color=C9D1D9&text_color=8B949E&icon_color=7F3FBF)](https://github.com/princeranjan03/Weather-WebApp)-->
<!--[![Todo-WebApp](https://github-readme-stats.vercel.app/api/pin/?username=princeranjan03&repo=Todo-WebApp&border_color=7F3FBF&bg_color=0D1117&title_color=C9D1D9&text_color=8B949E&icon_color=7F3FBF)](https://github.com/princeranjan03/Todo-WebApp)-->

<p align="center">
  <a href="https://github.com/princeranjan03">
    <img src="https://github-readme-streak-stats.herokuapp.com/?user=princeranjan03&theme=radical&border=7F3FBF&background=0D1117" alt="Prince's GitHub streak"/>
  </a>
</p>

<div align="center">
  <table>
    <tr>
      <td>
        <a href="https://github.com/princeranjan03">
          <img 
            alt="Prince's Github Stats" 
            src="https://denvercoder1-github-readme-stats.vercel.app/api?username=princeranjan03&show_icons=true&count_private=true&theme=react&border_color=7F3FBF&bg_color=0D1117&title_color=F85D7F&icon_color=F8D866" 
            width="400px" 
          />
        </a>
      </td>
      <td>
        <a href="https://github.com/princeranjan03">
          <img 
            alt="Prince's Top Languages" 
            src="https://denvercoder1-github-readme-stats.vercel.app/api/top-langs/?username=princeranjan03&langs_count=8&layout=compact&theme=react&border_color=7F3FBF&bg_color=0D1117&title_color=F85D7F&icon_color=F8D866" 
            width="400px" 
          />
        </a>
      </td>
    </tr>
  </table>
</div>


<div>
    <img src="https://cultofthepartyparrot.com/parrots/hd/githubparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/flags/hd/indiaparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/asyncparrot.gif" width="36" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/exceptionallyfastparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/60fpsparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/jumpingparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/opensourceparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/dealwithitnowparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/hypnoparrotlight.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/databaseparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/fixparrot.gif" width="36" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/laptop_parrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/spinningparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/levitationparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/meldparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/slomoparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/moonwalkingparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/stableparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/scienceparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/pirateparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/footballparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/illuminatiparrot.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/hypnoparrotdark.gif" width="30" height="30"/>
    <img src="https://cultofthepartyparrot.com/parrots/hd/mustacheparrot.gif" width="30" height="30"/>
</div>


