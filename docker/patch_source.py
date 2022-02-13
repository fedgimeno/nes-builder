
import os, glob

files = []

def listdirs(rootdir):    
    for it in os.scandir(rootdir):
        if it.is_file:
            if it.path.split('.')[-1] in allowed:
                files.append(os.path.join(it.path))   
        if it.is_dir():                        
            listdirs(it)


if __name__ == '__main__':
    allowed = ['asm','s']
    listdirs('./src')
    print(files)
    for f in files:        
        patched = ''
        filename = f.replace('./src/','').split('/')[-1]
        dir = f.replace(filename, '')
        fin = open (f, 'r')
        for item in fin:            
            changes = item
            item = item.strip()
            if 'INCLUDE' in item:
                inc_fn = item.split(' ')[-1]
                changes = item.replace(inc_fn, os.path.join(dir.replace('./src/','./in/'), inc_fn)) + '\n'
            patched = patched + changes
        fin.close()

        fout = open (os.path.join('./in', f.replace('./src/','')), 'w')
        fout.write(patched)
        fout.close()

