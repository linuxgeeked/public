#include <pcap.h>
#include <stdio.h>

int main() {
    char errbuf[PCAP_ERRBUF_SIZE];
    pcap_t *handle = pcap_open_offline("capture.pcap", errbuf);
    if (!handle) {
        fprintf(stderr, "Couldn't open file: %s\\n", errbuf);
        return 1;
    }

    struct pcap_pkthdr *header;
    const u_char *packet;
    int count = 0;

    while (pcap_next_ex(handle, &header, &packet) == 1) {
        count++;
    }

    printf("Total packets: %d\\n", count);
    pcap_close(handle);
    return 0;
}