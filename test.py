from csv2df import get_book_content, get_book_metadata

from create_xml import create_xml_file

create_xml_file(get_book_content(), get_book_metadata())

