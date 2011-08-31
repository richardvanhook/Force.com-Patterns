global class Metaphone implements Database.Batchable<SObject>{

    private String objectName;
    private String source;
    private String destination;

    private Metaphone(String objectName, String source, String destination){
        this.objectName = objectName;
        this.source = source;
        this.destination = destination;
    }

    global Database.QueryLocator start(Database.BatchableContext context){
        return Database.getQueryLocator('select ' + String.escapeSingleQuotes(source) 
            + ',' + String.escapeSingleQuotes(destination) 
            + ' from ' + String.escapeSingleQuotes(objectName));
    }

    global void execute(Database.BatchableContext context, List<SObject> records){
        calculate(records,source,destination);
        update records;
    }

    global void finish(Database.BatchableContext context){}

    global static ID calculate(String objectName, String source, String destination){
        return Database.executeBatch(new Metaphone(objectName,source,destination));
    }
    
    global static void calculate(List<SObject> records, String source, String destination){
        for(SObject record : records){
            record.put(destination,Metaphone.calculate(String.valueOf(record.get(source))));
        }
    }

    global static String calculate(String str){
        if(str == null) str = '';
        //Start with a string that is all uppercase
        String startStr = str.toUpperCase();

        String cs = '';  //this will be our "compare string"
        String result = ''; //this is our result which we will return at the end of this method      
        
        //check each letter in the string to see if the next letter is the same, if so, drop it, unless it is C
        for(Integer i=0;i<startStr.length()-1;i++){
            if(!startStr.substring(i,i+1).equals(startStr.substring(i+1,i+2)) || startStr.substring(i,i+1).equals('C')){
                cs += startStr.substring(i,i+1);   
            }
        }
        //Add the last letter of the string to the cs string since we didn't get to it in the loop above
        cs += startStr.substring(startStr.length()-1, startStr.length());
        
        //If the word begins with 'KN', 'GN', 'PN', 'AE', 'WR', drop the first letter.
        if( cs.startsWith('KN') ||
            cs.startsWith('GN') ||    
            cs.startsWith('PN') ||
            cs.startsWith('AE') ||
            cs.startsWith('WR')
          ){        
            cs = cs.substring(1,cs.length());
        }
        
        //Create a set containing the 5 vowels.  This will be used multiple times while checking for patterns
        Set<String> VOWELS = new Set<String>();
        VOWELS.add('A');
        VOWELS.add('E');
        VOWELS.add('I');
        VOWELS.add('O');
        VOWELS.add('U');
               
        if(cs.endsWith('MB')){
                cs = cs.substring(0,cs.length()-1);
        }
        
        //Create integer to hold length of the compare string.  cleans up the code a little. 
        Integer cslen = cs.length();
        
        //loop through the string and check each letter, matching against the metaphone patters.
        for(Integer i=0;i<cslen;i++){
            
                //If string starts with vowel, keep it, otherwise drop it.
                if(i==0){
                    for(String s : VOWELS){
                        if(cs.substring(0,1).equals(s)){ result += s; }                    
                    }
                }
            
            if(cs.substring(i,i+1).equals('B')){
                result += 'B';
                continue;
            }      
        
                //'C' transforms to 'X' if followed by 'IA' or 'H' (unless in latter case, it is part of '-SCH-', in which case it transforms to 'K').
                //'C' transforms to 'S' if followed by 'I', 'E', or 'Y'. Otherwise, 'C' transforms to 'K'.
                //CH transforms to K if at the beginning
                if(cs.substring(i,i+1).equals('C')){
                    if(i < cslen-2 && cs.substring(i+1,i+3).equals('IA')){
                        result += 'X';
                    }else if(i < cslen-1 && cs.substring(i+1,i+2).equals('H')){                      
                        if(i>0 && cs.substring(i-1,i).equals('S')){
                            result += 'K';
                            i++;                           
                        }else{
                            result += 'X';
                            i++;                            
                        }
                        }else if(i<cslen-1 && 
                             (cs.substring(i+1,i+2).equals('I') ||
                              cs.substring(i+1,i+2).equals('E') ||
                              cs.substring(i+1,i+2).equals('Y'))
                           ){
                                      
                        if(i>0 && cs.substring(i-1,i).equals('S')){
                                //do nothing and drop C, it is slient
                        }else{
                                result += 'S';
                        }                                                       
                    }else{
                        result += 'K';
                    }
                    continue;
                }
        
               //'D' transforms to 'J' if followed by 'GE', 'GY', or 'GI'. Otherwise, 'D' transforms to 'T'.
               if(cs.substring(i,i+1).equals('D')){
                    if(i<cslen-2 &&
                        (
                            cs.substring(i+1,i+3).equals('GE') ||
                            cs.substring(i+1,i+3).equals('GY') ||
                            cs.substring(i+1,i+3).equals('GI')           
                        )){                        
                        result += 'J';                  
                    }else{
                        result += 'T';
                    }
                    continue;
                }
                
                if(cs.substring(i,i+1).equals('F')){
                    result += 'F';
                    continue;
                }
        
                //Drop 'G' if followed by 'H' and 'H' is not at the end or before a vowel.            
                //Drop 'G' if followed by 'N' or 'NED' and is at the end.
                //'G' transforms to 'J' if before 'I', 'E', or 'Y', and it is not in 'GG'. Otherwise, 'G' transforms to 'K'. Reduce 'GG' to 'G'.                    
                if(cs.substring(i,i+1).equals('G')){
                    if((i==cslen-2 && cs.substring(i,i+2).equals('GN')) || (i==cslen-4 && cs.substring(i,i+4).equals('GNED'))){
                        //do nothing (ie drop G) since G is followed by N or NED and is at the end                      
                    }else if(i==0 && cslen >2 && cs.substring(1,2).equals('H') && VOWELS.contains(cs.substring(2,3))){
                        result += 'K'; //GH at the beginning should result in 'K'
                        i++;           //we know H is next and is taken care of, so skip it
                    }else if((i<cslen-2 && cs.substring(i+1,i+2).equals('H') && !VOWELS.contains(cs.substring(i+2,i+3))) || 
                                        (i<cslen-1 && cs.substring(i+1,i+2).equals('H'))){
                        //do nothing (ie drop G and H) since H is not followed by a vowel
                        i++;
                    }else if(i<cslen-1 && 
                              (cs.substring(i+1,i+2).equals('I')||
                               cs.substring(i+1,i+2).equals('E') ||
                               cs.substring(i+1,i+2).equals('Y')
                              )
                            ){
                        result += 'J';
                        if(cs.substring(i+1,i+2).equals('Y')){ //then y is considered a vowel here
                                i++;
                        }
                    }else{
                        result += 'K';
                        //if(i<cslen-2 && cs.substring(i+1,i+2).equals('H')){ // H is not at end and is silent here
                        //      i++;
                        //      continue;
                        //}
                    }
                    continue;                
                }
        
                //Drop 'H' if after vowel and not before a vowel.
                if(cs.substring(i,i+1).equals('H')){                            
                    if(i>0 && VOWELS.contains(cs.substring(i-1,i))){
                        //we have a vowel before H                    
                        if((i<cslen-1 && !VOWELS.contains(cs.substring(i+1,i+2))) || i==cslen-1){
                            //do nothing since a vowel is after H as well
                        }else{
                            result += 'H'; //H is at the end or not followed by a vowel
                        }    
                    }else{
                        result += 'H';
                    }
                    continue;
                }
                
                if(cs.substring(i,i+1).equals('J')){
                    result += 'J';
                    continue;
                }
                
                //'CK' transforms to 'K'.
                if(cs.substring(i,i+1).equals('K')){
                    if(i>0 && cs.substring(i-1,i).equals('C')){
                        //do nothing since the K is silent (the C was already transformed to K earlier
                    }else{
                        result +='K';
                    } 
                    continue;
                }
                
                if(cs.substring(i,i+1).equals('L')){
                    result += 'L';
                    continue;
                }
                
                if(cs.substring(i,i+1).equals('M')){
                    result += 'M';
                    continue;
                }
                
                if(cs.substring(i,i+1).equals('N')){
                    result += 'N';
                    continue;
                }
        
                //'PH' transforms to 'F'. (the H will get dropped later)
                if(cs.substring(i,i+1).equals('P')){
                    if(i<cslen-1 && cs.substring(i+1,i+2).equals('H')){
                        result += 'F';
                        i++;                    
                     }else{
                        result += 'P';
                    }
                    continue;
                }
                
        
                //'Q' transforms to 'K'.
                if(cs.substring(i,i+1).equals('Q')){
                    result += 'K';
                    continue;
                }
                
                if(cs.substring(i,i+1).equals('R')){
                    result += 'R';
                    continue;
                }
        
                //'S' transforms to 'X' if followed by 'H', 'IO', or 'IA'.
                if(cs.substring(i,i+1).equals('S')){
                    if( (i<cslen-1 && cs.substring(i+1,i+2).equals('H')) ||
                        (i<cslen-2 && (cs.substring(i+1,i+3).equals('IO') || cs.substring(i+1,i+3).equals('IA') ))
                      ){
                        result += 'X';
                        if(cs.substring(i+1,i+2).equals('H')){
                                i++;
                        }              
                    }else{
                        result += 'S';                  
                    }
                    continue;
                }
        
                //'T' transforms to 'X' if followed by 'IA' or 'IO'. 'TH' transforms to '0'. Drop 'T' if followed by 'CH'.
                if(cs.substring(i,i+1).equals('T')){
                    if(i<cslen-2 && (cs.substring(i+1,i+3).equals('IO') || cs.substring(i+1,i+3).equals('IA'))){
                        result += 'X';
                    }else if(i<cslen-1 && cs.substring(i+1,i+2).equals('H')){
                        result += '0'; //this is a zero, representing 'theta'
                        i++; //TH just became 0 so drop the H is no needed.
                    }else if(i<cslen-2 && cs.substring(i+1,i+3).equals('CH')){
                        //do nothing since T is followed by CH and thus gets dropped
                    }else{
                        result += 'T';
                    }
                    continue;
                } 
        
                //'V' transforms to 'F'.       
                if(cs.substring(i,i+1).equals('V')){
                    result += 'F';
                    continue;
                }
        
                //'WH' transforms to 'W' if at the beginning (done earlier). Drop 'W' if not followed by a vowel.
                if(cs.substring(i,i+1).equals('W')){
                    if(i==0 && cslen>1 && cs.substring(i+1,i+2).equals('H')){
                        result+='W';
                        i++;
                    }else if(i<cslen-1 && VOWELS.contains(cs.substring(i+1,i+2))){
                        result += 'W';                    
                    } 
                    continue;               
                }
        
                //'X' transforms to 'S' if at the beginning. Otherwise, 'X' transforms to 'KS'.
                if(cs.substring(i,i+1).equals('X')){
                    if(i==0){
                        result += 'S';
                    }else{
                        result += 'KS';
                    }
                    continue;
                }
                
                //Drop 'Y' if not followed by a vowel.
                if(cs.substring(i,i+1).equals('Y')){
                    if(i<cslen-1 && VOWELS.contains(cs.substring(i+1,i+2))){
                        result += 'Y';                    
                    }
                    continue;                       
                }
        
                //'Z' transforms to 'S'.                
                if(cs.substring(i,i+1).equals('Z')){
                    result += 'S';
                    continue;
                }
                        
        }//end for loop
        return result;
    }

    
    
}