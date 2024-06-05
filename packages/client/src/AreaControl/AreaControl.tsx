import { useState } from "react";
import Setup from "./Setup";
import OngoingGameInfo from "./OngoingGameInfo";

export interface IAreaControlData {
  teamACount: number;
  teamBCount: number;
  taken?: boolean;
  taker?: "A" | "B";
  teamAScore?: number;
  teamBScore?: number;
  userTeam?: "A" | "B";
  haveToken?: boolean;
}

export interface AreaControlProps {
  data: IAreaControlData;
}

const AreaControl: React.FC<AreaControlProps> = ({ data }: AreaControlProps): JSX.Element => {
  const [hasStarted, setHasStarted] = useState<boolean>(false)

  return (
    <>
      { !hasStarted && <Setup data={data} hasStarted={hasStarted} setHasStarted={setHasStarted} /> }
      { hasStarted && <OngoingGameInfo data={data} /> }
    </>
  )
}

export default AreaControl