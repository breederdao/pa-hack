import { useEffect, useRef, useState } from "react"
import MainButton from "../components/buttons/MainButton"

const StartGameButton = ({setHasStarted}: {setHasStarted: (hasStarted: boolean)=>void}) => {
  const [countdown, setCountdown] = useState<number>(3)
  const countDownID = useRef<number | null>(null)
  const [isStarting, setIsStarting] = useState<boolean>(false)

  useEffect(()=>{
    if (countdown === 0 && countDownID.current && typeof countDownID.current === 'number') {
      setHasStarted(true)
      clearInterval(countDownID.current);
      countDownID.current = null;
    }
  },[countdown, countDownID, setHasStarted])

  function updateCountdown() {
    setCountdown((prevCount) => prevCount - 1);
  }

  function handleStart() {
    setIsStarting(true)
    setCountdown(3)
    const intervalId = setInterval(updateCountdown, 1000);
    countDownID.current = intervalId as unknown as number;
  }

  return (
    <>
      <div className="font-normal text-sm leading-[22px] text-center">
        {
          isStarting && countdown === 0 ? 'You may now close this window' : 'Players complete'
        }
      </div>
      <MainButton disabled={isStarting} onClick={!isStarting ? handleStart : undefined}>
        {
          !isStarting ? 'Start Game' : `Game starting in ${countdown}...`
        }
      </MainButton>
    </>
  )
}

export default StartGameButton