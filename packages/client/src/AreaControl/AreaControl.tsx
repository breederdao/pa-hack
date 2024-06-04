import { useState } from "react";
import Setup from "./Setup";
import OngoingGameInfo from "./OngoingGameInfo";

export interface IAreaControlData {
  teamACount: number;
  teamBCount: number;
}

export interface AreaControlProps {
  data: IAreaControlData;
}

const AreaControl: React.FC<AreaControlProps> = ({ data }: AreaControlProps): JSX.Element => {
  const [hasStarted, setHasStarted] = useState<boolean>(false)

  return (
    <>
      { !hasStarted && <Setup data={data} hasStarted={hasStarted} setHasStarted={setHasStarted} /> }
      { hasStarted && <OngoingGameInfo /> }
    </>
  )
}

export default AreaControl