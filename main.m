
clear all;
clc

% world_map = [3 1 1 1 2 1 3 1 3 1 1 2 1 1 1 3 1 1 2 1 1 1 1 2 1];
world_map = [2 3 3 3 1 3 1 3 2 3 3 3 3 1 3 3 2 3 3 3 3 3 3 1 2];

% disp(world_map);

belief = ones(1,25).*(1/25);
% disp(belief);
 

pred_belief = zeros(1,25);
% disp(pred_belief);

%4 Motion Models for L,R,F,B


for i=1:25
    for j=1:25
            if(i==j)
                model_R(i,j)=0.1;

            elseif (i==j-1)
                model_R(i,j)=0.8;

            elseif (i==j-2)
                model_R(i,j)=0.1;

            else
                model_R(i,j)=0;
            end 
        
    end 
end




% Forward matrix

for i=1:25
    for j=1:25
            if(i==j)
                model_F(i,j)=0.1;

            elseif (i==j+5)
                model_F(i,j)=0.8;

            elseif (i==j+10)
                model_F(i,j)=0.1;

            else
                model_F(i,j)=0;
            end 
        
    end 

end

% Backward matrix
model_L=transpose(model_R);
model_B=transpose(model_F);




%Measurement Model --> 1. Blue 2. White 3. Yellow

% colors=["Red","Blue","Black"];
%1,2,0 

% measurement_model = [0.1 0.1 0.1 0.1 0.7 0.1 0.1 0.1 0.1 0.1 0.1 0.7 0.1 0.1 0.1 0.1 0.1 0.1 0.7 0.1 0.1 0.1 0.1 0.7 0.1 ;
%                      0.1 0.7 0.7 0.7 0.1 0.7 0.1 0.7 0.1 0.7 0.7 0.1 0.7 0.7 0.7 0.1 0.7 0.7 0.1 0.7 0.7 0.7 0.7 0.1 0.7;
%                      0.7 0.1 0.1 0.1 0.1 0.1 0.7 0.1 0.7 0.1 0.1 0.1 0.1 0.1 0.1 0.7 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1];

% disp(measurement_model);

red=ones(1,25)./10;
red_prob=0.7;
red(1)=red_prob;
red(9)=red_prob;
% red(11)=red_prob;
red(17)=red_prob;
% red(22)=red_prob;
red(25)=red_prob;

blue_prob=0.7;
blue=ones(1,25)./10;
blue(5)=blue_prob;
blue(7)=blue_prob;
blue(14)=blue_prob;
blue(24)=blue_prob;

black_prob=0.7;
black=ones(1,25)./10;
black(2)=black_prob;
black(3)=black_prob;
black(4)=black_prob;
black(6)=black_prob;
black(8)=black_prob;
black(10)=black_prob;
black(11)=black_prob;
black(12)=black_prob;
black(13)=black_prob;
black(15)=black_prob;
black(16)=black_prob;
black(18)=black_prob;
black(19)=black_prob;
black(20)=black_prob;
black(21)=black_prob;
black(22)=black_prob;
black(23)=black_prob;

measurement_model= [blue;red;black];

pi_obj = raspi('hanslanda','pi','hello@123456');

cam=webcam(pi_obj);
for t = 1:7
    ut = input("R/L/F/B : ","s");

    if ut=="R"
     
        motion_model = model_R;

    elseif ut=="L"

        motion_model=model_L;
   
    elseif ut=='F'

        motion_model=model_F;

    elseif ut=="B"

        motion_model=model_B;
    end

%     measurement=input("color:");
    measurement = color_detection(cam);
    disp(measurement)




    %Prediction step
    
    for i = 1 : length(pred_belief)
        pred_belief(i) = 0;
        for j = 1 : length(belief)
            pred_belief(i) = pred_belief(i) + (motion_model(j, i) * belief(j));
        end 
    end
    
    pred_belief
    
    %Updation step
    
    for i = 1 : length(pred_belief)
        belief(i) = measurement_model(measurement, i) * pred_belief(i);
    end
    eta = 1 / (sum(belief));
    belief = belief * eta;
    
    belief
    heatmap(belief)
end