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
    playstat=0;
    pausestat=0;
    quitstat=0;
    snakevel=1;
    speedmultiplier=1;
% % % % % % 
    foodNum = 3;
    arenaindex=1;
    gameModeTab = 1;%1:classic, 2:survival
    gameState = struct;
%     info.method = 'Monte-Carlo'; 
%     info.method = 'alphaBeta'; 
%     info.method = 'miniMax';
%     info.method = 'Monte-Carlo-1';
%     method = {'miniMax', 'alphaBeta', 'Monte-Carlo-1', 'Monte-Carlo-2', 'Monte-Carlo-3', 'Monte-Carlo-4'};
    method = {'Monte-Carlo-1', 'Monte-Carlo-2', 'Monte-Carlo-3', 'Monte-Carlo-4', 'Monte-Carlo-1', 'Monte-Carlo-1'};
    info.depth = 2;
    info.growTime = 5;
    keyDir = 'none';
% % % % % %   
    %defind AI snakes
    aiSnakeNumTab = 0;
    aiSnakeNum = aiSnakeNumTab+1;% number of AI snakes
    PlayByMySelfTab = 1;
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
    mainwindow=figure('Name','AI�j�D�Y',...
                      'NumberTitle','Off',...
                      'Menubar','none',...
                      'Resize','off',...
                      'Units','pixels',...
                      'Position',[0.5*(ScreenSize(3)-440),...
                                  0.5*(ScreenSize(4)-430),...
                                  440,430],...
                      'WindowKeyPressFcn',@pressfcn,...
                      'WindowKeyReleaseFcn',@releasefcn,...
                      'DeleteFcn',@closegamefcn);
    axes('Parent',mainwindow,...
         'Units','pixel',...
         'Position',[52,130,280,280]);
    %lscoretext=uicontrol('Parent',mainwindow,...
    %                     'Style','text',...
    %                     'String','0',...
    %                     'FontSize',15,...
    %                     'HorizontalAlignment','center',...
    %                     'BackgroundColor',[0.8,0.8,0.8],...
    %                     'Units','pixels',...
    %                     'Position',[10,220,40,40]);
%     rscoretext=uicontrol('Parent',mainwindow,...
%                          'Style','text',...
%                          'String','0',...
%                          'FontSize',15,...
%                          'HorizontalAlignment','center',...
%                          'BackgroundColor',[0.8,0.8,0.8],...
%                          'Units','pixels',...
%                          'Position',[334,220,70,100]);
    arenapopup=uicontrol('Parent',mainwindow,...
                         'Style','popup',...
                         'String',{'Infinite',...
                                   'Cage',...
                                   'Track Field',...
                                   'Puzzle'},...
                         'Units','normalized',...
                         'Position',[0.36,0.25,0.17,0.025],...
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
                         'Position',[0.54,0.225,0.1,0.05],...
                         'Callback',@selectAINumfcn);
     playmyself=uicontrol('Parent',mainwindow,...
                     'Style','popup',...
                     'String',{'Myself',...
                               'AI Demo'},...
                     'Units','normalized',...
                     'Position',[0.65,0.225,0.15,0.05],...
                     'Callback',@selectIfPlay);
    gameModeSelect=uicontrol('Parent',mainwindow,...
             'Style','popup',...
             'String',{'Classic',...
                       'Survival'},...
             'Units','normalized',...
             'Position',[0.18,0.25,0.17,0.025],...
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
                         
                         
     gameState.wall = deffield{arenaindex};
     gameState.field = generatefieldarray(gameState);
     drawfield(gameState.field)
%Declaring LocalFunction
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
                idx = field(row,col)-10;
                if mod(idx,2)
                    idx = ceil(idx/2);
                    color = snakeColor(idx);
                    color = color(1,:);
                else
                    idx = idx/2;
                    color = snakeColor(idx);
                    color = color(2,:);
                end
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
                if ~strcmpi(gameState.snake(1).dir,'down')
                    keyDir = 'up';
                end
            case 'uparrow'
                if ~strcmpi(gameState.snake(1).dir,'down')
                    keyDir = 'up';
                end
            case 's'
                if ~strcmpi(gameState.snake(1).dir,'up')
                    keyDir = 'down';
                end
            case 'downarrow'
                if ~strcmpi(gameState.snake(1).dir,'up')
                    keyDir = 'down';
                end
            case 'a'
                if ~strcmpi(gameState.snake(1).dir,'right')
                    keyDir = 'left';
                end
            case 'leftarrow'
                if ~strcmpi(gameState.snake(1).dir,'right')
                    keyDir = 'left';
                end
            case 'd'
                if ~strcmpi(gameState.snake(1).dir,'left')
                    keyDir = 'right';
                end
            case 'rightarrow'
                if ~strcmpi(gameState.snake(1).dir,'left')
                    keyDir = 'right';
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
        arenaindex = get(arenapopup,'Value');
        gameState.wall = deffield{arenaindex};
        gameState.field = generatefieldarray(gameState);
        drawfield(gameState.field)
        set(instructionbox,'String',['Arena was set to ',...
                                     num2str(arenaindex)])
    end
    function selectAINumfcn(~,~)
        aiSnakeNumTab = get(aiNum,'Value')-1;
        set(instructionbox,'String',['We have ',...
                                     num2str(aiSnakeNumTab),' AI Snakes'])
    end

    function selectIfPlay(~,~)
        PlayByMySelfTab = get(playmyself,'Value');
    end

%Start of AIagent
    function selectGameMode(~,~)
        gameModeTab=get(gameModeSelect,'Value');
        if  gameModeTab ==1
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
        % initiatin ai snake 
        clear gameState 
        gameState.wall = deffield{arenaindex};
        gameState.size = [28 28];
        aiSnakeNum = aiSnakeNumTab+1;
        snakescore = zeros(1,aiSnakeNum);
        rscoretext2 = cell(aiSnakeNum,1);
        PlayByMySelf = PlayByMySelfTab;
        for i = 1 : aiSnakeNum                 
            color = snakeColor(i);
            rscoretext2{i}=uicontrol('Parent',mainwindow,...
                     'Style','text',...
                     'String','0',...
                     'FontSize',15,...
                     'HorizontalAlignment','center',...
                     'BackgroundColor',[0.8,0.8,0.8],...
                     'ForegroundColor',color(1,:)./280,...
                     'Units','pixels',...
                     'Position',[334,300-30*i,100,100]); 
            [pos, dir] = snakeInitTable(i);
            gameState.snake(i).pos = pos;
            gameState.snake(i).dir = dir;
            gameState.snake(i).life = 1;
            gameState.snake(i).lose = 0;
            gameState.snake(i).win = 0;
            gameState.snake(i).grow = 0;
        end
        gameState.gameMode = gameModeTab;
        snakevel = get(speedslider,'Value');
        gameState.time = 0;
        gameState.field = generatefieldarray(gameState);
        %Placing initial food
        count=1;
        while count<=foodNum
            gameState.food(count,1)=1+round(27*rand);
            gameState.food(count,2)=1+round(27*rand); 
            if gameState.field(gameState.food(count,1),gameState.food(count,2))==0                   
                count=count+1;
            end
        end
        
        %Redrawing graphics
        gameState.field = generatefieldarray(gameState);
        drawfield(gameState.field)
        
        %Performing loop for the game
        while playstat==1
            %Creating loop for game pause
            while pausestat
                pause(0.01)
                set(instructionbox,'String','Game paused!')
            end
            gameState.time = gameState.time+1;

            % set Interface      and decide next moves
            snakedir = cell(1,aiSnakeNum);
            for i = 1 : aiSnakeNum
                if PlayByMySelf==1 && i==1
                    if ~strcmp(keyDir,'none')
                        snakedir{1} = keyDir;
                    else
                        snakedir{1} = gameState.snake(1).dir;
                    end
                    keyDir = 'none';
                else
                    info.method = method{i};
                    snakedir{i} = searchAgent( gameState, i, info );
                end
            end

            %snake move
            gameState = generateSuccessor(gameState, snakedir, info);

            %Adding new food
            while size(gameState.food,1)<foodNum
                foodpos = [1+round(27*rand) 1+round(27*rand)];
                if gameState.field(foodpos(1),foodpos(2))==0
                    gameState.food = [gameState.food; foodpos];
                end
            end
            
            %Checking game over
            for i = 1 : aiSnakeNum
                if gameState.snake(i).win
                    playstat = 0;
                    set(instructionbox,'String',['Snake ' num2str(i) ' win!'])
                    break
                end
            end

            %Moving snake forward
            for i = 1 : aiSnakeNum
                if gameState.snake(i).lose==1
%                     snakescore(i) =snakescore(i);
                else
                    snakescore(i) = size(gameState.snake(i).pos,1);
                end
                str = [num2str(snakescore(i)), '/',num2str(gameState.snake(i).life)];
               set(rscoretext2{i},'String',str)
%                 set(rscoretext2{i},'String',num2str(snakescore(i)))
            end
    
            %Updating graphics
            gameState.field = generatefieldarray(gameState);
            drawfield(gameState.field)
            gameState.time = gameState.time+1;
            %Performing delay
           % set(lscoretext,'String',num2str(snakescore))
%             set(rscoretext,'String',num2str(snakescore))
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