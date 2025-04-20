if isinstance(v, bytes):
                    #     encoder = json.detect_encoding(v)
                    #     try:
                    #         v = v.decode(encoder)
                    #     except UnicodeDecodeError:
                    #         v = v.decode('utf-16')