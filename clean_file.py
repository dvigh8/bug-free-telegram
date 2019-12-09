import os
from pathlib import Path
import phonenumbers


if __name__=='__main__':

    file_name = "whatsapp_chat.txt"
    file_path = os.path.join(Path.home(),"Documents")

    
    with open(os.path.join(file_path,file_name),'r') as f_in, open(os.path.join(file_path, "cleaned_" + file_name),'w') as f_out:
        for l in f_in:
            line = l
            matcher = phonenumbers.PhoneNumberMatcher(line, "US")
            match = matcher.next() if matcher.has_next() else None
            if match is not None:
                line = line[:match.start] + phonenumbers.format_number(match.number, phonenumbers.PhoneNumberFormat.E164) + line[match.end:]
            f_out.write(line)
    print(file_name + " is cleaned")
