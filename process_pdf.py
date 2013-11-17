#!/usr/bin/env python
import copy, sys,os
from pyPdf import PdfFileWriter, PdfFileReader

#read files
path='/Users/yanhualiu/Desktop/plots/'
files=os.listdir(path)
#select the pdf file
ispdf=lambda file: True if '.pdf' in file else False
pdffile=filter(ispdf,files)

#get time step number
getstep=lambda inname:inname[:6]
timestep=sorted(set(map(getstep,pdffile)))

#loop to combine pdf files
for step in timestep:
    #look for matching time step
    matching = [s for s in pdffile if step in s]
    # open a output file
    outputStream = file(path+step+"_zoom_summary.pdf", "wb")
    output = PdfFileWriter()
    #loop time step to find input
    for anyfile in matching:
        input=PdfFileReader(file(path+anyfile,"rb"))
         # remove the blank page, that's the bug of idl
        output.addPage(input.getPage(1))
        os.remove(path+anyfile)
    output.write(outputStream)
    outputStream.close()


