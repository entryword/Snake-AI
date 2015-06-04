function Snake

%--------------------------------------------------------------------------
%Snake
%Version 1.00
%Created by Stepen
%Created 26 November 2011
%Last modified 4 December 2012
%--------------------------------------------------------------------------
%Snake starts GUI game of classic snake.
%--------------------------------------------------------------------------
%How to play Snake:
%Player collects score by controlling the snake's movement using w-s-a-d
%button or directional arrow button to the food while avoid crashing the
%walls and its own tail. Use shift to speed up your snake, ctrl to slow
%down your snake, and p to pause your game.
%--------------------------------------------------------------------------

%CodeStart-----------------------------------------------------------------
%Reseting MATLAB environment
    close all
    clear all
%Declaring global variables
    fieldWidth = 28;
    playstat=0;
    pausestat=0;
    quitstat=0;
    field=zeros(28);
    arenaindex=1;
    gameMode = 1;%1:classic, 2:survival
    snakepos=zeros(8,2);
    snakevel=1;
    snakedir='right';
    truedir='right';
    snakescore=0;
    foodpos=zeros(3,2);
    speedmultiplier=1;
    %defind AI snakes
    aiSnakeNumTab = 0;
    aiSnakeNum = aiSnakeNumTab;% number of AI snakes
    aiSnakeColorTab = [190, 180, 65; 236, 218, 19; 103, 108, 152; 42, 59, 213; 96, 47, 47;149, 106, 106;0, 61, 61;0, 138, 138;133, 66, 0;235, 117, 0];
    aiSnakeColor = aiSnakeColorTab;
    aiSnakePos = cell(aiSnakeNum,1);
    aiSnakeDir = cell(aiSnakeNum,1);
    aiSnakeTrueDir = cell(aiSnakeNum,1);
    aiSnakePosTab = zeros(8,2,5);
    aiSnakePosTab(:,1,1) = 3; 
    aiSnakePosTab(:,2,1) =  18:1:25;
    aiSnakePosTab(:,1,2) = [12,11,10,9,9,10,11,12]; 
    aiSnakePosTab(:,2,2) =  [3,3,3,3,2,2,2,2];
    aiSnakePosTab(:,1,3) = [18,17,16,15,15,16,17,18]; 
    aiSnakePosTab(:,2,3) =  [3,3,3,3,2,2,2,2];
    aiSnakePosTab(:,1,4) = [15,14,13,12,12,13,14,15]; 
    aiSnakePosTab(:,2,4) =  [26,26,26,26,27,27,27,27];
    aiSnakePosTab(:,1,5) = 27; 
    aiSnakePosTab(:,2,5) = 24:-1:17;
    aiSnakeDirTab = {'left'; 'right';'right';'left';'right'};
    aiSnakeTrueDirTab = {'left';'down';'down';'down';'right'};
%Defining variables for deffield
    deffield=cell(1,3);
    deffield{1}=zeros(28);
    deffield{2}=zeros(28);
    deffield{2}([1,28],:)=9;
    deffield{2}(:,[1,28])=9;
    deffield{3}=zeros(28);
    deffield{3}([1,28],:)=9;
    deffield{3}(:,[1,28])=9;
    deffield{3}(6:23,6:23)=9;
    deffield{4}=zeros(28);
    deffield{4}(2:6:28,1:20)=9;
    deffield{4}(29:-6:1,28:-1:9)=9;
%Generating GUI
    ScreenSize=get(0,'ScreenSize');
    mainwindow=figure('Name','AI¤j³D¤Y',...
                      'NumberTitle','Off',...
                      'Menubar','none',...
                      'Resize','off',...
                      'Units','pixels',...
                      'Position',[0.5*(ScreenSize(3)-384),...
                                  0.5*(ScreenSize(4)-430),...
                                  384,430],...
                      'WindowKeyPressFcn',@pressfcn,...
                      'WindowKeyReleaseFcn',@releasefcn,...
                      'DeleteFcn',@closegamefcn);
    axes('Parent',mainwindow,...
         'Units','pixel',...
         'Position',[52,130,280,280]);
    lscoretext=uicontrol('Parent',mainwindow,...
                         'Style','text',...
                         'String','0',...
                         'FontSize',15,...
                         'HorizontalAlignment','center',...
                         'BackgroundColor',[0.8,0.8,0.8],...
                         'Units','pixels',...
                         'Position',[10,220,40,40]);
    rscoretext=uicontrol('Parent',mainwindow,...
                         'Style','text',...
                         'String','0',...
                         'FontSize',15,...
                         'HorizontalAlignment','center',...
                         'BackgroundColor',[0.8,0.8,0.8],...
                         'Units','pixels',...
                         'Position',[334,220,40,40]);
    arenapopup=uicontrol('Parent',mainwindow,...
                         'Style','popup',...
                         'String',{'Infinite',...
                                   'Cage',...
                                   'Track Field',...
                                   'Puzzle'},...
                         'Units','normalized',...
                         'Position',[0.46,0.25,0.17,0.025],...
                         'Callback',@selectarenapopupfcn);
    aiNum=uicontrol('Parent',mainwindow,...
                         'Style','popup',...
                         'String',{'0',...
                                   '1',...
                                   '2',...
                                   '3',...
                                   '4',...
                                   '5'},...
                         'Units','normalized',...
                         'Position',[0.64,0.225,0.1,0.05],...
                         'Callback',@selectAINumfcn);
    gameModeSelect=uicontrol('Parent',mainwindow,...
             'Style','popup',...
             'String',{'Classic',...
                       'Survival'},...
             'Units','normalized',...
             'Position',[0.28,0.25,0.17,0.025],...
             'Callback',@selectGameMode);
    speedslider=uicontrol('Parent',mainwindow,...
                          'Style','slider',...
                          'Value',1,...
                          'Min',1,...
                          'Max',100,...
                          'SliderStep',[1/99,2/99],...
                          'Units','normalized',...
                          'Position',[0.375,0.155,0.25,0.03],...
                          'Callback',@movespeedsliderfcn);
    speedtext=uicontrol('Parent',mainwindow,...
                        'Style','text',...
                        'String','1',...
                        'HorizontalAlignment','center',...
                        'BackgroundColor',[0.8,0.8,0.8],...
                        'Units','normalized',...
                        'Position',[0.475,0.12,0.05,0.03]);
    startbutton=uicontrol('Parent',mainwindow,...
                          'Style','pushbutton',...
                          'String','Start Game',...
                          'Visible','on',...
                          'Units','normalized',...
                          'Position',[0.12,0.15,0.2,0.05],...
                          'Callback',@startgamefcn);
    stopbutton=uicontrol('Parent',mainwindow,...
                         'Style','pushbutton',...
                         'String','Stop Game',...
                         'Visible','off',...
                         'Units','normalized',...
                         'Position',[0.12,0.15,0.2,0.05],...
                         'Callback',@stopgamefcn);
    uicontrol('Parent',mainwindow,...
              'Style','pushbutton',...
              'String','Close Game',...
              'Units','normalized',...
              'Position',[0.67,0.15,0.2,0.05],...
              'Callback',@closegamefcn);
    instructionbox=uicontrol('Parent',mainwindow,...
                             'Style','text',...
                             'String',['Click Start Game button to',...
                                       ' begin the game...'],...
                             'Units','normalized',...
                             'Position',[0.1,0.05,0.8,0.04]);
%Inititiating graphics
    field=generatefieldarray(deffield,snakepos,foodpos);
    drawfield(field)
%Declaring LocalFunction
    %Start of generatefieldarray
    function field=generatefieldarray(deffield,snakepos,foodpos)
        field=deffield{arenaindex};
        for count=1:length(snakepos)
            if ~((snakepos(count,1)==0)||(snakepos(count,2)==0))
                field(snakepos(count,1),snakepos(count,2))=1;
                if count==1
                    field(snakepos(1,1),snakepos(1,2))=2;
                end
            end
        end
        for count=1:length(foodpos)
            if ~((foodpos(count,1)==0)||(foodpos(count,2)==0))
                field(foodpos(count,1),foodpos(count,2))=5;
            end
        end
        for i = 1: aiSnakeNum
            for count = 1:size(aiSnakePos{i},1)
                aiPos = aiSnakePos{i};
                if ~((aiPos(count,1)==0)||(aiPos(count,2)==0))            
                    field(aiPos(count,1),aiPos(count,2))=10+i*2;
                    if count==1
                        field(aiPos(1,1),aiPos(1,2))=10+i*2-1;     
                    end
                end
            end
        end
    end
    %End of generatefieldarray
    %Start of drawfield
    function drawfield(field)
        %Preparing array for field graphic
        graphics=uint8(zeros(280,280,3));
        %Calculating field graphic array
        for row=1:28
        for col=1:28
            %Drawing wall
            if field(row,col)==9
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=0;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=0;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=0;
            end
            %Drawing snake
            if field(row,col)==1
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=0;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=128;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=0;
            end
            %Drawing snake's head
            if field(row,col)==2
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=0;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=64;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=0;
            end
            %Drawing food
            if field(row,col)==5
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=255;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=0;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=0;
            end
            %Drawing ground
            if field(row,col)==0
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=0;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=255;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=0;
            end
            if field(row,col)>10 
                color = aiSnakeColor(field(row,col)-10,:);
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=color(1);
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=color(2);
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=color(3);
            end
        end
        end
        %Drawing graphic
        imshow(graphics)
    end
    %End of drawfield
%Declaring CallbackFunction
    %Start of pressfcn
    function pressfcn(~,event)
        switch event.Key
            case 'w'
                if ~strcmpi(truedir,'down')
                    snakedir='up';
                end
            case 'uparrow'
                if ~strcmpi(truedir,'down')
                    snakedir='up';
                end
            case 's'
                if ~strcmpi(truedir,'up')
                    snakedir='down';
                end
            case 'downarrow'
                if ~strcmpi(truedir,'up')
                    snakedir='down';
                end
            case 'a'
                if ~strcmpi(truedir,'right')
                    snakedir='left';
                end
            case 'leftarrow'
                if ~strcmpi(truedir,'right')
                    snakedir='left';
                end
            case 'd'
                if ~strcmpi(truedir,'left')
                    snakedir='right';
                end
            case 'rightarrow'
                if ~strcmpi(truedir,'left')
                    snakedir='right';
                end
            case 'shift'
                speedmultiplier=10;
            case 'control'
                speedmultiplier=0.5;
            case 'p'
                pausestat=1-pausestat;
        end
    end
    %End of pressfcn
    %Start of releasefcn
    function releasefcn(~,event)
        switch event.Key
            case 'shift'
                speedmultiplier=1;
            case 'control'
                speedmultiplier=1;
        end
    end
    %End of releasefcn
    %Start of selectarenapopup
    function selectarenapopupfcn(~,~)
        arenaindex=get(arenapopup,'Value');
        field=generatefieldarray(deffield,snakepos,foodpos);
        drawfield(field)
        set(instructionbox,'String',['Arena was set to ',...
                                     num2str(arenaindex)])
    end
    function selectAINumfcn(~,~)
        aiSnakeNumTab=get(aiNum,'Value')-1;
        field=generatefieldarray(deffield,snakepos,foodpos);
        drawfield(field)
        set(instructionbox,'String',['We have ',...
                                     num2str(aiSnakeNumTab),' AI Snakes'])
    end

%Start of AIagent
    function selectGameMode(~,~)
        gameMode=get(gameModeSelect,'Value');
        field=generatefieldarray(deffield,snakepos,foodpos);
        drawfield(field)
        if gameMode ==1
            tempstr = 'Classic Mode!';
        else
            tempstr = 'Survival!!!!!';
        end
        set(instructionbox,'String',tempstr)
    end
    %End of selectarenapopup
    %Start of speedsliderfcn
    function movespeedsliderfcn(~,~)
        snakevel=get(speedslider,'Value');
        snakevel=round(snakevel);
        set(speedtext,'String',num2str(snakevel))
        set(instructionbox,'String',['Snake speed was set to ',...
                                     num2str(snakevel)])
    end
    %End of speedsliderfcn
    %Start of startgamefcn
    function startgamefcn(~,~)
        %Locking user interface
        set(startbutton,'Visible','off')
        set(stopbutton,'Visible','on')
        set(arenapopup,'Enable','off')
        set(speedslider,'Enable','off')
        %Resetting variables
        playstat=1;
        snakepos=zeros(8,2);
        snakepos(:,1)=25;
        snakepos(:,2)=15:-1:8;
        snakevel=get(speedslider,'Value');
        snakedir='right';
        snakescore=0;
        % initiatin ai snake        
        aiSnakeNum = aiSnakeNumTab;
        for i = 1: aiSnakeNum
           aiSnakePos{i} = aiSnakePosTab(:,:,i);
        end   
        aiSnakeDir = aiSnakeDirTab(1:aiSnakeNum);
        aiSnakeTrueDir =aiSnakeTrueDirTab(1:aiSnakeNum);
        aiSnakeColor = aiSnakeColorTab;
        %Initiating graphics
        
        field=generatefieldarray(deffield,snakepos,foodpos);
        drawfield(field)
        %Placing initial food
        count=1;
        while count<4
            foodpos(count,1)=1+round(27*rand);
            foodpos(count,2)=1+round(27*rand);
            if field(foodpos(count,1),foodpos(count,2))==0
                count=count+1;
            end
        end
        %Redrawing graphics
        field=generatefieldarray(deffield,snakepos,foodpos);
        drawfield(field)
        %Performing loop for the game
        while playstat==1
            %Creating loop for game pause
            while pausestat
                pause(0.01)
                set(instructionbox,'String','Game paused!')
            end

            aiNextMovePos= cell(aiSnakeNum,1);
            eatenFood = [];
            addstat=0;
            for i = 1:aiSnakeNum
               tempPos=aiSnakePos{i};
               tempDir = aiSnakeDir{i};
               [aiNextMovePos{i},aiSnakeTrueDir{i}]  = cekNextMove(tempPos,tempDir); 
               aiGrowStat = zeros(aiSnakeNum,1);
               tempnextmovepos = aiNextMovePos{i};
               if field(tempnextmovepos(1),tempnextmovepos(2))==5
                   aiGrowStat(i)=1;
                   eatenFood = [eatenFood;tempnextmovepos ];
                   addstat=1;
               end
            end
            %Calculating snake's forward movement  
            if strcmpi(snakedir,'left')
                nextmovepos=[snakepos(1,1),snakepos(1,2)-1];
                truedir='left';
                if nextmovepos(2)==0
                    nextmovepos(2)=28;
                end
            elseif strcmpi(snakedir,'right')
                nextmovepos=[snakepos(1,1),snakepos(1,2)+1];
                truedir='right';
                if nextmovepos(2)==29
                    nextmovepos(2)=1;
                end
            elseif strcmpi(snakedir,'up')
                nextmovepos=[snakepos(1,1)-1,snakepos(1,2)];
                truedir='up';
                if nextmovepos(1)==0
                    nextmovepos(1)=28;
                end
            elseif strcmpi(snakedir,'down')
                nextmovepos=[snakepos(1,1)+1,snakepos(1,2)];
                truedir='down';
                if nextmovepos(1)==29
                    nextmovepos(1)=1;
                end
            end


            %Checking snake's forward movement position for food
            if field(nextmovepos(1),nextmovepos(2))==5
                growstat=1;
                addstat = 1;
                eatenFood = [eatenFood; nextmovepos];
            else
                growstat=0;
            end
                %Deleting eaten food


            if addstat ==1
                tempFoodPos = [];
                for count=1:3
                    for countF = 1:size(eatenFood,1)
                        if ~isequal(eatenFood(countF,:),foodpos(count,:))
                            tempFoodPos = [tempFoodPos;foodpos(count,:)];
                            %break
                        end
                    end
                end
                foodpos = tempFoodPos;
                %Adding new food
                addstat=1;
                while size(foodpos,1)<3
                    while addstat==1
                        foodpos(3,1)=1+round(27*rand);
                        foodpos(3,2)=1+round(27*rand);
                        if field(foodpos(3,1),foodpos(3,2))==0
                            addstat=0;
                        end
                    end
                addstat =1;
                end
            end
            %Checking snake's forward movement for wall
            if (field(nextmovepos(1),nextmovepos(2))>0)&&...
               (field(nextmovepos(1),nextmovepos(2))~=5)
                set(instructionbox,'String','Ouch! Game over!')
                playstat=0;
                break
            end
            count = 1;
            while count <= aiSnakeNum
                tempnextmovepos = aiNextMovePos{count};
                
                if (field(tempnextmovepos(1),tempnextmovepos(2))>0)&&...
                (field(tempnextmovepos(1),tempnextmovepos(2))~=5)
                    aiSnakeNum = aiSnakeNum-1;
                    aiNextMovePos(count)=[];
                    aiGrowStat(count)=[];
                    aiSnakeTrueDir(count)=[];
                    aiSnakeDir(count)=[];
                    aiSnakePos(count)=[];
                    aiSnakeColor(count*2-1:count*2,:)=[];
                    count = count-1;
                end
                count = count+1;
            end
            
            %Moving snake forward
            if growstat==1
                snakepos=[nextmovepos;snakepos(1:length(snakepos),:)];
                snakescore=snakescore+1;
                set(instructionbox,'String','Yummy!')
            else
                snakepos=[nextmovepos;snakepos(1:length(snakepos)-1,:)];
                set(instructionbox,'String','Watch out for walls!')
            end
            for i = 1:aiSnakeNum
                if aiGrowStat(i)==1
                    aiSnakePos{i}=[aiNextMovePos{i}; aiSnakePos{i}(1:length( aiSnakePos{i}),:)];

                else
                    aiSnakePos{i}=[aiNextMovePos{i};aiSnakePos{i}(1:length( aiSnakePos{i})-1,:)];
                end
            end
            
            %Updating graphics
            field=generatefieldarray(deffield,snakepos,foodpos);
            drawfield(field)
            %Performing delay
            set(lscoretext,'String',num2str(snakescore))
            set(rscoretext,'String',num2str(snakescore))
            pause(0.1/(speedmultiplier*snakevel))
        end
        %Unlocking user interface
        if quitstat==0
            set(startbutton,'Visible','on')
            set(stopbutton,'Visible','off')
            set(arenapopup,'Enable','on')
            set(speedslider,'Enable','on')
        end
    end
    %End of startgamefcn
    %Start of stopgamefcn
    
    function [nextmovepos,tempTrueDir]  = cekNextMove(tempPos,tempDir)
        if strcmpi(tempDir,'left')
                nextmovepos=[tempPos(1,1),tempPos(1,2)-1];
                tempTrueDir='left';
                if nextmovepos(2)==0
                    nextmovepos(2)=28;
                end
            elseif strcmpi(tempDir,'right')
                nextmovepos=[tempPos(1,1),tempPos(1,2)+1];
                tempTrueDir='right';
                if nextmovepos(2)==29
                    nextmovepos(2)=1;
                end
            elseif strcmpi(tempDir,'up')
                nextmovepos=[tempPos(1,1)-1,tempPos(1,2)];
                tempTrueDir='up';
                if nextmovepos(1)==0
                    nextmovepos(1)=28;
                end
            elseif strcmpi(tempDir,'down')
                nextmovepos=[tempPos(1,1)+1,tempPos(1,2)];
                tempTrueDir='down';
                if nextmovepos(1)==29
                    nextmovepos(1)=1;
                end
        end
    end
    
    function stopgamefcn(~,~)
        %Stopping game loop
        playstat=0;
        %Displaying instruction
        set(instructionbox,...
            'String','Game stopped! Press start to begin new game...')
    end
    %End of stopgamefcn
    %Start of closegamefcn
    function closegamefcn(~,~)
        %Stopping game loop
        playstat=0;
        quitstat=1;
        pause(0.5)
        %Closing all windows
        delete(mainwindow)
    end
    %End of closegamefcn
%CodeEnd-------------------------------------------------------------------

end