import pytest
import glob
import os
from lxml import etree


def validate_xml_file(file):
    try:
        print("Testing {}".format(file))
        etree.parse(file)
        return True
    except etree.XMLSyntaxError:
        print("Failed on {}".format(file))
        return False


def test_config_files():
    files = glob.glob(os.getcwd() + '/**/*.config', recursive=True)

    for file in files:
        xml_validation = validate_xml_file(file)
        assert xml_validation is True


if __name__ == "__main__":
    test_config_files()
