import ucsv as csv
import os, glob
import sys
import xlsxwriter
import tinys3
import time
import json

def convert(list_of_indexes, sheet_names):
    list_of_indexes = list_of_indexes
    listOfFiles = glob.glob("./data/in/tables/*.csv")
    sheet_names = sheet_names
    
    excelFile = xlsxwriter.Workbook('./data/in/tables/CE_WK' + '.xlsx')
    hidden = excelFile.add_format()
    hidden.set_hidden()
    for index, fileInList in enumerate(listOfFiles):
        worksheet = excelFile.add_worksheet(str(sheet_names[index]))
        worksheet.protect()
        with open(fileInList, 'rb') as f:
            content = csv.reader(f)
            for index_row, data_in_row in enumerate(content):
                for index_col, data_in_cell in enumerate(data_in_row):
                    
                    if index_col  in list_of_indexes[index]:
                        if type(data_in_cell) == int or type(data_in_cell) == float:
                            temp = '=TEXT(%d,\"*#*,######\")' % (data_in_cell)
                            worksheet.write_formula(index_row, index_col, temp, hidden)
                        elif data_in_cell == ' ':
                                worksheet.write_blank(index_row, index_col, None)
                        elif type(data_in_cell) == unicode:
                            worksheet.write(index_row, index_col, unicode(data_in_cell))
                        else:
                            worksheet.write(index_row, index_col, unicode(data_in_cell))
                    else:
                        if data_in_cell == ' ':
                            worksheet.write_blank(index_row, index_col, None)
                        elif (type(data_in_cell) == int or type(data_in_cell) == float) and data_in_cell != ' ' :
                            worksheet.write_number(index_row, index_col, data_in_cell)
                        else:
                            worksheet.write(index_row, index_col, unicode(data_in_cell))
    print " === conversion is done ==="
    excelFile.close()
    
    
