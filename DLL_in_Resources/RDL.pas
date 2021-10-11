{ Par Bacterius : Resourced Dynamic Library }
{ www.delphifr.com - suite � une question de kopierreko }

unit RDL;

interface

uses Windows, SysUtils, Classes;

type
 TRDL = class
 private
  FLinked: Boolean;        { D�finit si la liaison a bien eu lieu }
  FLink: Longword;         { Contient le descripteur de liaison }
  FResourceName: String;   { Contient le nom de ressource de la DLL }
  FProcNames: TStringList; { Contient la liste des noms de proc�dures }
  FProcAddresses: TList;   { Contient la liste des pointeurs vers les proc�dures }
 protected
  function ExtractAndLink: Boolean; { Effectue l'extraction puis la liaison de la DLL }
  procedure Unlink;                 { D�tache la DLL }
 public
  constructor Create(AResourceName: String); reintroduce; { Cr�ation du composant - extraction et liaison }
  destructor Destroy; override;                           { Destruction du composant - d�tachement }
  function AddProcName(ProcName: String): Boolean;        { Ajoute une proc�dure dans la liste }
  function GetFunction(ProcName: String): Pointer;        { R�cup�re l'adresse d'une fonction list�e }
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
   Path := Format('%s%s.dll', [ExtractFilePath(ParamStr(0)), FResourceName]); { On met la DLL � c�t� de l'exe }
   M.SaveToFile(Path); { On enregistre la ressource dans un fichier }
   FLink := LoadLibrary(PChar(Path)); { On tente de lier la DLL par un appel � LoadLibrary }
   Result := (FLink <> 0); { Si la DLL a bien �t� li�e, on renvoie True }
  finally
   M.Free; { On lib�re le TStream quoi qu'il arrive }
  end;
 except
  { Rien }
 end;
end;

procedure TRDL.Unlink;
begin
 { Si la DLL est li�e, on la d�tache par un appel � FreeLibrary }
 if FLinked then FreeLibrary(FLink);
end;

function TRDL.AddProcName(ProcName: String): Boolean;
Var
 P: Pointer;
begin
 { Ici on ajoute une proc�dure de la DLL dans la liste. Renvoie True si la proc�dure existe et si elle a
   bien �t� li�e, False en cas d'erreur. }
 P := GetProcAddress(FLink, PChar(ProcName)); { On r�cup�re l'adresse de la proc�dure dans la DLL }
 Result := (P <> nil);  { Si GetProcAddress renvoie nil, la fonction a �chou�, sinon, on renvoie True }
 if Result then { Si on a bien trouv� la proc�dure ... }
  begin
   FProcNames.Add(ProcName); { On ajoute le nom de la proc�dure dans la liste }
   FProcAddresses.Add(P); { On ajoute l'adresse de la fonction dans l'autre liste }
  end;
end;

function TRDL.GetFunction(ProcName: String): Pointer;
Var
 N: Integer;
begin
 { Ici, on r�cup�re l'adresse d'une proc�dure de la DLL. Il faut que la proc�dure ait �t� pr�alablement
   repertori�e par AddProcName. }
 N := FProcNames.IndexOf(ProcName); { On r�cup�re la position de la proc�dure dans la liste }
 if N > -1 then Result := FProcAddresses.Items[N] else Result := nil; { On prend l'adresse � cette position }
end;

constructor TRDL.Create(AResourceName: String);
begin
 inherited Create;
 FResourceName:= AResourceName;
 FLinked := ExtractAndLink; { On lie la DLL }
 FProcNames := TStringList.Create; { On cr�e les listes }
 FProcAddresses := TList.Create;
end;

destructor TRDL.Destroy;
begin
 FProcAddresses.Free; { On lib�re les listes }
 FProcNames.Free;
 Unlink;        { On d�tache la DLL }
 inherited Destroy;
end;

end.
