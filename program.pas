uses graphABC;

type
  cell = record
    
    Bomb: Boolean;
    Numb: integer;
    Closeness: Boolean;
    Flag: Boolean;
    Question: Boolean;
    Revelation: Boolean;
    constructor Create(Bomb: Boolean; Numb: integer; Closeness: Boolean; Flag: Boolean; Question: Boolean; Revelation: Boolean);
    begin
      Self.Bomb := Bomb;
      Self.Numb := Numb;
      Self.Closeness := Closeness;
      Self.Flag := Flag;
      Self.Question := Question;
      Self.Revelation := Revelation;
    end;
  end;

const
  sq = 10;

var
  flags: integer;
  field: array [0..sq + 1, 0..sq + 1] of cell;
  img: array [1..16] of string;
  pic: array [1..16] of picture;
  start_x, start_y: integer;
  flag: boolean;
  bombs: array[1..sq * sq div 5 + 1, 1..2] of integer;
  bbb, nnn: array[0..sq + 1, 0..sq + 1] of integer;
  defeat: boolean;
  BN: integer;

function bombsNumber(): integer;
var
  s: integer;
begin
  for var i := 1 to sq do
    for var j := 1 to sq do
      if field[i][j].Bomb then s += 1;
  Result := s;
end;

function winCondition(): boolean;
var
  flag_: boolean;
begin
  flag_ := True;
  for var i := 1 to sq do 
    for var j := 1 to sq do
      if field[i][j].Bomb and (field[i][j].Flag = False) then flag_ := False;
  if flag_ then begin
    textout(0, 20, 'VICTORY!!!');
    
  end;
end;

procedure Draw(pic: picture; x, y: integer);
begin
  for var i := 1 to 10 do pic.Draw(x, y);
end;

function inBombs(x, y: integer): Boolean;
var
  s: boolean;
begin
  s := False;
  for var i := 1 to BN + 1 do
    if ((bombs[i][1] = x) and (bombs[i][2] = y)) or ((x = start_x) and (y = start_y)) then s := True;
  Result := s;
end;


procedure empty(x, y: integer);
begin
  field[x][y].Revelation := True;
  if field[x][y].Numb = 0 then begin
    if field[x][y].flag then begin
      field[x][y].flag := not field[x][y].flag;
      flags += 1;
    end;
    sleep(20);
    Draw(pic[2], x * 50 - 50, y * 50);
    for var i := -1 to 1 do
      for var j := -1 to 1 do
        if not field[x + i][y + j].Revelation then empty(x + i, y + j);
  end
  else if field[x][y].Numb > 0 then begin
    if field[x][y].flag then begin
      field[x][y].flag := not field[x][y].flag;
      flags += 1;
    end;
    sleep(20);
    Draw(pic[field[x][y].Numb + 6], x * 50 - 50, y * 50 );
    
  end;
end;


procedure MouseDown_(x, y, button: integer);
var
  counter, x1, y1: integer;
begin
  if (x > sq * 50 - 79) and (y > 7) and (x < sq * 50 - 2) and (y < 30) then begin
    Execute('program.exe');
    
    halt;
  end;
  if (x > 0) and (x < sq * 50) and (y > 50) and (y < (sq + 1) * 50) then begin
    
    if flag and (button = 1) then begin
      
      flags := BN;
      counter := 0;
      start_x := (x div 50) + 1;
      start_y := ((y - 50) div 50) + 1;
      //textout(0, 0, inttostr(start_x));
      //textout(0, 20, inttostr(start_y));
      flag := False;
      x1 := -1;
      y1 := -1;
      bombs[BN + 1][1] := x1;
      bombs[BN + 1][2] := y1;
      for var i := 1 to BN do 
      
      begin
        while inBombs(x1, y1) do 
        begin
          
          x1 := random(1, sq);
          y1 := random(1, sq);
          
          
        end;
        bombs[i][1] := x1;
        bombs[i][2] := y1;
      end;
      for var i := 0 to sq + 1 do 
      begin
        for var j := 0 to sq + 1 do 
        begin
          if (i = start_x) and (j = start_y) then field[i][j] := new cell(False, 0, True, False, False, False)
          else  if (i = 0) or (i = sq + 1) or (j = 0) or (j = sq + 1) then field[i][j] := new cell(True, -1, True, False, False, False);
          
          
        end;
      end;
      
      for var i := 1 to BN do
        field[bombs[i][1]][bombs[i][2]] := new cell(True, 0, True, False, False, False);
      
      
      
      for var i := 1 to sq do                           
        for var j := 1 to sq do
          if not field[i][j].Bomb then begin
            for var k := -1 to 1 do
              for var l := -1 to 1 do
                if field[i + k][j + l].Bomb and (field[i + k][j + l].Numb <> -1) then counter += 1;
            field[i][j].Numb := counter;
            counter := 0;
            nnn[i][j] := field[i][j].Numb;                   //ÑÀÌÎÏÐÎÂÅÐÊÀ (ÄËß ÎÒËÀÒÊÈ)
            
          end;
      
      
      for var i := 0 to sq + 1 do                                //ÑÀÌÎÏÐÎÂÅÐÊÀ (ÄËß ÎÒËÀÒÊÈ)
        for var j := 0 to sq + 1 do                             //
        begin
          if field[i][j].bomb then bbb[i][j] := 1             //
          else bbb[i][j] := 0;                               // 
        end;
      
      
      
      
      
      
    end;
    
    //for var i := 0 to sq+1 do
    // for var j := 0 to sq+1 do textout(60 + i * 20 + 450, j * 20, bbb[i][j]);
    
    if (button = 1) and (not defeat) then begin
      
      //textout(20, 0, field[(x div 50) + 1][((y - 50) div 50) + 1].Numb);
      //textout(40, 0, nnn[(x div 50) + 1][((y - 50) div 50) + 1]);
      //textout(70, 0, (x div 50) + 1);
      //textout(70, 20, ((y - 50) div 50) + 1);
      if field[(x div 50) + 1][((y - 50) div 50) + 1].Numb > 0 then 
      begin
        Draw(pic[field[(x div 50) + 1][((y - 50) div 50) + 1].Numb + 6], ((x div 50) + 0) * 50, (((y - 50) div 50) + 1) * 50); 
        field[(x div 50) + 1][((y - 50) div 50) + 1].Revelation := True;
      end
      
      else if field[(x div 50) + 1][((y - 50) div 50) + 1].Bomb then begin
        textout(0, 20, 'DEFEAT');
        defeat := True;
        Draw(pic[16], ((x div 50) ) * 50, (((y - 50) div 50) + 1) * 50);
        field[(x div 50) + 1][((y - 50) div 50) + 1].Bomb := False;
        for var i := 1 to sq do
          for var j := 1 to sq do begin
            if field[i][j].Bomb and not field[i][j].Flag then Draw(pic[1], i * 50 - 50, j * 50);
            if not field[i][j].Bomb and field[i][j].Flag then Draw(pic[6], i * 50 - 50, j * 50);
          end;
        
      end
      else if field[(x div 50) + 1][((y - 50) div 50) + 1].Numb = 0 then begin
        //pic[2].Draw(((x div 50) + 0) * 50, (((y - 50) div 50) + 1) * 50);
        empty((x div 50) + 1, ((y - 50) div 50) + 1);      
        //field[(x div 50) + 1][((y - 50) div 50) + 1].Revelation := True; //ÂÎ ÒÓÒ ÄÎËÆÍÅÍ ÁÛÒÜ ÂÛÇÎÂ ÔÓÍÊÖÈÈ Ñ ÐÅÊÓÐÑÈÅÉ
      end;
    end
    
    else if (button = 2) and (not flag) and (not defeat) then begin
      if not field[(x div 50) + 1][((y - 50) div 50) + 1].Revelation then begin
        if field[(x div 50) + 1][((y - 50) div 50) + 1].Question then begin
          pic[3].Draw(((x div 50) + 0) * 50, (((y - 50) div 50) + 1) * 50);
          field[(x div 50) + 1][((y - 50) div 50) + 1].Question := False;
        end
        
        else if not field[(x div 50) + 1][((y - 50) div 50) + 1].Flag then begin
          if flags > 0 then begin
            pic[4].Draw(((x div 50) + 0) * 50, (((y - 50) div 50) + 1) * 50);
            field[(x div 50) + 1][((y - 50) div 50) + 1].Flag := True; 
            flags -= 1;
          end;
        end
        else if field[(x div 50) + 1][((y - 50) div 50) + 1].Flag then begin
          pic[5].Draw(((x div 50) + 0) * 50, (((y - 50) div 50) + 1) * 50);
          field[(x div 50) + 1][((y - 50) div 50) + 1].Question := True;
          field[(x div 50) + 1][((y - 50) div 50) + 1].Flag := False; 
          flags += 1;
        end;
      end; 
    end;
    
    if bombsNumber() <> 0 then begin textout(0, 0, 'Flags left ' + inttostr(flags) + '             '); winCondition(); end;
  end;
end;





procedure gui;
var
  x, y: integer;
begin
  
  BN := (sq * sq) div 5;
  defeat := False;
  SetWindowSize(sq * 50, (sq + 1) * 50);
  SetWindowIsFixedSize(True);
  DrawRectangle(sq * 50 - 79, 7, sq * 50 - 2, 30); 
  textout(sq * 50 - 72, 10, 'New game');
  img[1] := 'bomb.png';
  img[2] := 'zero.png';
  img[3] := 'closed.png';
  img[4] := 'flaged.png';
  img[5] := 'inform.png';
  img[6] := 'nobomb.png';
  img[7] := 'num1.png';
  img[8] := 'num2.png';
  img[9] := 'num3.png';
  img[10] := 'num4.png';
  img[11] := 'num5.png';
  img[12] := 'num6.png';
  img[13] := 'num7.png';
  img[14] := 'num8.png';
  img[15] := 'opened.png';
  img[16] := 'bombed.png';
  for var i := 1 to 16 do 
  begin
    pic[i] := picture.Create(img[i]);
    pic[i].load(img[i]);
  end;
  for var i := 0 to sq - 1 do
    for var j := 0 to sq - 1 do
      pic[3].draw(i * 50, j * 50 + 50);
  flag := True;
  
  OnMouseDown := MouseDown_;
  
  
end;



procedure MouseDown(x, y, button: integer);
begin
  
end;

begin
  //MinimizeWindow;
  gui;
  //OnMouseDown := MouseDown;
end.