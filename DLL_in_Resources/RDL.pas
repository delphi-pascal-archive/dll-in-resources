{ Par Bacterius : Resourced Dynamic Library }
{ www.delphifr.com - suite à une question de kopierreko }

unit RDL;

interface

uses Windows, SysUtils, Classes;

type
 TRDL = class
 private
  FLinked: Boolean;        { Définit si la liaison a bien eu lieu }
  FLink: Longword;         { Contient le descripteur de liaison }
  FResourceName: String;   { Contient le nom de ressource de la DLL }
  FProcNames: TStringList; { Contient la liste des noms de procédures }
  FProcAddresses: TList;   { Contient la liste des pointeurs vers les procédures }
 protected
  function ExtractAndLink: Boolean; { Effectue l'extraction puis la liaison de la DLL }
  procedure Unlink;                 { Détache la DLL }
 public
  constructor Create(AResourceName: String); reintroduce; { Création du composant - extraction et liaison }
  destructor Destroy; override;                           { Destruction du composant - détachement }
  function AddProcName(ProcName: String): Boolean;        { Ajoute une procédure dans la liste }
  function GetFunction(ProcName: String): Pointer;        { Récupère l'adresse d'une fonction listée }
 published
  property Linked: Boolean      read FLinked;
  property ResourceName: String read FResourceName;
 end;

implementation

function TRDL.ExtractAndLink: Boolean;
Var
 M: TResourceStream;
 Path: String;
begin
 Result := False;
 try
  try
   M := TResourceStream.Create(HInstance, FResourceName, RT_RCDATA); { On ouvre la DLL en ressource }
   Path := Format('%s%s.dll', [ExtractFilePath(ParamStr(0)), FResourceName]); { On met la DLL à côté de l'exe }
   M.SaveToFile(Path); { On enregistre la ressource dans un fichier }
   FLink := LoadLibrary(PChar(Path)); { On tente de lier la DLL par un appel à LoadLibrary }
   Result := (FLink <> 0); { Si la DLL a bien été liée, on renvoie True }
  finally
   M.Free; { On libère le TStream quoi qu'il arrive }
  end;
 except
  { Rien }
 end;
end;

procedure TRDL.Unlink;
begin
 { Si la DLL est liée, on la détache par un appel à FreeLibrary }
 if FLinked then FreeLibrary(FLink);
end;

function TRDL.AddProcName(ProcName: String): Boolean;
Var
 P: Pointer;
begin
 { Ici on ajoute une procédure de la DLL dans la liste. Renvoie True si la procédure existe et si elle a
   bien été liée, False en cas d'erreur. }
 P := GetProcAddress(FLink, PChar(ProcName)); { On récupère l'adresse de la procédure dans la DLL }
 Result := (P <> nil);  { Si GetProcAddress renvoie nil, la fonction a échoué, sinon, on renvoie True }
 if Result then { Si on a bien trouvé la procédure ... }
  begin
   FProcNames.Add(ProcName); { On ajoute le nom de la procédure dans la liste }
   FProcAddresses.Add(P); { On ajoute l'adresse de la fonction dans l'autre liste }
  end;
end;

function TRDL.GetFunction(ProcName: String): Pointer;
Var
 N: Integer;
begin
 { Ici, on récupère l'adresse d'une procédure de la DLL. Il faut que la procédure ait été préalablement
   repertoriée par AddProcName. }
 N := FProcNames.IndexOf(ProcName); { On récupère la position de la procédure dans la liste }
 if N > -1 then Result := FProcAddresses.Items[N] else Result := nil; { On prend l'adresse à cette position }
end;

constructor TRDL.Create(AResourceName: String);
begin
 inherited Create;
 FResourceName:= AResourceName;
 FLinked := ExtractAndLink; { On lie la DLL }
 FProcNames := TStringList.Create; { On crée les listes }
 FProcAddresses := TList.Create;
end;

destructor TRDL.Destroy;
begin
 FProcAddresses.Free; { On libère les listes }
 FProcNames.Free;
 Unlink;        { On détache la DLL }
 inherited Destroy;
end;

end.
