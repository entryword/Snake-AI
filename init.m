%Reseting MATLAB environment
    close all
    clear all
%Declaring global variables
    fieldWidth = 28;
    foodNum = 3;
    playstat=0;
    pausestat=0;
    quitstat=0;
    field=zeros(28);
    arenaindex=1;
    gameModeTab = 1;%1:classic, 2:survival
    gameMode = gameModeTab;
    snakepos=zeros(8,2);
    snakevel=1;
    snakedir='right';
    truedir='right';
    snakescore=0;
    foodpos=zeros(foodNum,2);
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
    snakeLife=zeros(aiSnakeNum+1,1);
    snakeWin=zeros(aiSnakeNum+1,1);
    snakeLose=zeros(aiSnakeNum+1,1);
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