grammar com.zenika.doclipser.dsl.DockerfileDsl with org.eclipse.xtext.common.Terminals
 
import "http://www.eclipse.org/emf/2002/Ecore" as ecore

generate dockerfileDsl "http://www.zenika.com/docker/dsl/DockerfileDsl"

Dockerfile:
  (instructions+=Instruction)+;
  
Instruction:
    Add|Cmd|Copy|Entrypoint|Expose|Env|From|Maintainer|Onbuild|Run|User|Volume|Workdir;
    
Cmd:
    'CMD' (JSON_ARRAY | {Cmd}ONE_SPACE_AND_WHATEVER)
;

Copy returns AddDestination:
    'COPY ' (JSON_ARRAY |source_left=AddSource dest=ONE_SPACE_AND_WHATEVER)
;

Entrypoint:
    'ENTRYPOINT' (JSON_ARRAY | {Cmd}ONE_SPACE_AND_WHATEVER)
;

Volume:
    'VOLUME' (JSON_ARRAY | {Volume}ONE_SPACE_AND_WHATEVER)
;

User:
    'USER ' name=ID
;

Onbuild:
    'ONBUILD ' instruction=Instruction
;   
    
From:
    'FROM ' name=VALID_IMAGE_NAME (':' tag=VALID_IMAGE_TAG)?
;

Maintainer:
    'MAINTAINER' name=ONE_SPACE_AND_WHATEVER
;

Env:
    'ENV ' (EnvWithSpace|EnvWithEqual)
;

Expose:
 'EXPOSE' ports=ONE_SPACE_AND_WHATEVER
;

JSON_ARRAY:
    '[' head=STRING tail+=(STRING_PREFIXED_WITH_COMMA)* ']'
;

//Expose:
// 'EXPOSE' (ports+=Addition)
//;

//INT_LIST_WITH_COMMA_SEPARATOR:
// 'EXPOSE' (',' ports+=INT)+
//;
//
//INT_LIST_WITH_SPACE_SEPARATOR:
// (ports+=INT)+
//;
//
//
//
//ExposePorts hidden(ML_COMMENT):
//  {ExposePorts} (INT_PREFIXED_BY_SPACE)+ 
//;
//
//Addition returns Expression:
//  Primary ({Addition.left=current} right=Primary)*;
//  
//Primary returns Expression:
//  (NumberLiteral | {Expression}' ' INT)
//;
//  
//NumberLiteral:
//  value=INT;


EnvWithSpace:
    key+=ID value+=ONE_SPACE_AND_WHATEVER
;

EnvWithEqual:
    (key+=ID value+=ENV_VALUE_WITH_EQUAL)+
;

Workdir:
    'WORKDIR' path=ONE_SPACE_AND_WHATEVER
;

Add returns AddDestination:
    'ADD ' source_left=AddSource dest=ONE_SPACE_AND_WHATEVER
;

AddSource:
    VALID_RELATIVE_PATH | VALID_URL | '.'
;

//AddDestination:
//  VALID_PATH
//;

Run:
    'RUN' RunWithShell|RunWithNoShell
;

RunWithShell:
    command=ONE_SPACE_AND_WHATEVER
;

RunWithNoShell:
    '[' executable=STRING params+=(STRING_PREFIXED_WITH_COMMA)* ']'
;

STRING_PREFIXED_WITH_COMMA:
    ',' STRING
;

VALID_RELATIVE_PATH returns ecore::EString:
//  ' ' ID('/' ID)*
    (ID('/' ID)*)('*')?
;

VALID_URL returns ecore::EString:
    ('http://' ID(('/'|'.') ID)*)
;

INT_PREFIXED_BY_SPACE:
    INT (' '|'\n'|'\r')
;

VALID_IMAGE_NAME returns ecore::EString : 
  ID ('/' ID)*
;

VALID_IMAGE_TAG returns ecore::EString :
	(ID|INT|STRING)(ID|INT|STRING|'-'|'.')*
;


terminal SL_COMMENT : '#' !('\n'|'\r')* ('\r'? '\n')?;
terminal ONE_SPACE_AND_WHATEVER: ' '!('\n' | '\r')*  ('\r'? '\n')?;
terminal ENV_VALUE_WITH_EQUAL: '='!('\n' | '\r' | ' ')*' '?;