% Your code here.

img = imread('../images/01_list.jpg');
[lines, bw] = findLetters(img);
pause(3);
clf;
img = imread('../images/02_letters.jpg');
[lines, bw] = findLetters(img);
pause(3);
clf;
img = imread('../images/03_haiku.jpg');
[lines, bw] = findLetters(img);
pause(3);
clf;
img = imread('../images/04_deep.jpg');
[lines, bw] = findLetters(img);