void split_ip(const char* ip, unsigned int octets[4]) {
    unsigned int i = 0;
    unsigned int octet_index = 0;
    unsigned int current_octet = 0;

    for (int i = 0; ip[i] != '\0' && octet_index < 4; i++) {
        if (ip[i] == '.') {
            octets[octet_index++] = current_octet;
            current_octet = 0;
        } else {
            current_octet = current_octet * 10 + (ip[i] - '0');
        }
    }

    if (octet_index < 4) {
        octets[octet_index] = current_octet;
    }
}

unsigned int ip_to_int(const char* ip) {
    unsigned int octets[4];
    split_ip(ip, octets);
    return (octets[3] << 24) | (octets[2] << 16) | (octets[1] << 8) | octets[0];
}
