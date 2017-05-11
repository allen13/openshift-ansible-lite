import base64
import hashlib


def sha1_password(password):
    return "{SHA}" + format(base64.b64encode(hashlib.sha1(password).digest()))

class FilterModule (object):
    def filters(self):
        return {"sha1_password": sha1_password}
