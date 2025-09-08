import os from "os";

const utilHelper = {
    /**
     * 현재 시스템의 IP주소를 조회하여 배열로 리턴한다.
     * @returns {Array}
     */
    myip: () => {
        const nets = os.networkInterfaces();

        return Object.values(nets)
            .flat()
            .filter(v => v.family === "IPv4" && v.address !== "127.0.0.1")
            .map(v => v.address);
    },
};

export default utilHelper;