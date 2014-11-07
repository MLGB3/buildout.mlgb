import sys 

def application(environ, start_response):
    status = '200 OK'

    output = ''
    output += 'sys.version = %s\n' % repr(sys.version)
    output += 'sys.prefix = %s\n' % repr(sys.prefix)

    response_headers = [('Content-type', 'text/plain'),
                        ('Content-Length', str(len(output)))]
    start_response(status, response_headers)

    return [output]

